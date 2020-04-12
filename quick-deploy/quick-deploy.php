<?php
/**
 * Quick and dirty deploy script for Git repositories.
 *
 * Basic idea: you have a Git server (like Gitea, but just a bare repo should
 * also work) where you host a repo that you want to deploy somewhere. The
 * somewhere (same or other server) has a Web Server with PHP capabilities
 * running (my use case: I develop a TYPO3 site package, TYPO3 runs on PHP).
 * In your Git repo (server-side) you define post-receive git hook which just
 * sends a simple HTTP GET request your deploy-server (over HTTTPS, of course)
 * like https://example.com/quick-deploy.php?s=YOUR_SECRET. Where your secret
 * is known to you, your git post-receive hook and the quick-deploy script.
 * If the given secret matches the predefinded than a pull request in the given
 * repository is attempted. It git fails, a 500 error will be returned.
 * Additionally the git output will be printed.
 *
 * For the configuration look at config.example.json. Copy it and ajust it for
 * a working setup.
 *
 * PHP version 7
 *
 * @package    QuickDeploy
 * @author     Marcel Kapfer <opensource@mmk2410.org>
 * @copyright  2020 Marcel Kapfer
 * @license    https://opensource.org/licenses/MIT MIT License
 * @version    v0.0.1
 */

/**
 * Position of the configuration JSON file.
 */
define("CONFIG_FILE", "config.json");

/**
 * Parse and print Git output.
 *
 * The output of a git command with the --progress flag is a little bit
 * hard to parse. The progress messages need to be splited first and
 * then printed.
 *
 * @param string $output output of a git command execution
 *
 * @return void
 */
function print_git_output($output)
{
    foreach ($output as &$line) {
        $line = preg_split("/\r\n|\n|\r/", $line);
        foreach ($line as &$subline) {
            echo($subline . "<br>");
        }
    }
}

/**
 * Print something bold (<b></b>) and end with newline.
 *
 * Handy wrapper of the echo function which prints the text wrapped with a
 * "<b></b>" tag and end with a <br>.
 *
 * @param string $output string to print in bold
 *
 * @return void
 */
function print_bold($output)
{
    echo("<b>" . $output . "</b><br>");
}

/**
 * Handle shell exit status.
 *
 * Checks if the exist status is zero or not and prints $action combined with a
 * status message (failed or successful) as bold text.
 *
 * @param int $return_var exit code of called command
 * @param string $action name/description of tried action
 *
 * @return void
 */
function handle_status($return_var, $action)
{
    if ($return_var != 0) {
        handle_error($action . " failed");
    } else {
        print_bold($action . " successful");
    }
}

/**
 * Print error and set HTTP status code.
 *
 * Print a error message in bold and set a 500 HTTP Error status. Additionally
 * it exits the process.
 *
 * @param string $error_msg Error message that should be printed.
 *
 * @return void
 */
function handle_error($error_msg)
{
    print_bold($error_msg);
    http_response_code(500);
    exit();
}

/**
 * Read and parse configuration.
 *
 * Read the JSON configuration defined in CONFIG_FILE and parse it.
 *
 * @return array|null configuration
 */
function parse_config()
{
    if (is_readable(CONFIG_FILE)) {
        $config_data = file_get_contents(CONFIG_FILE);
        return json_decode($config_data, true);
    } else {
        handle_error("Config file not found or not readable");
    }
}

/**
 * Verify and complete config.
 *
 * The configuration values "secret", "local-path" and "remote-path"  are
 * checked for existence and "branch" is set to "master" if not defined.
 *
 * @param array $config configuration array
 *
 * @return void
 */
function verify_config(&$config)
{
    # Check if secret is set (config and GET parameter).
    if (!isset($_GET["secret"])) {
        handle_error("No secret given.");
    }

    # Check if local path is set
    if (!isset($config["local-path"])) {
        handle_error("No local path given.");
    }

    # Check if remote path is set
    if (!isset($config["remote-path"])) {
        handle_error("No remote path given.");
    }

    # Define branch name
    if (!isset($config["branch"])) {
        $config["branch"] = master;
    }
}

/**
 * Authenticate using the given secrets.
 *
 * Compares the secret stored in the configuration and the one given as secret
 * get parameter.
 *
 * @param string $secret secret defined in the configuration
 *
 * @return void
 */
function authenticate($secret)
{
    # Check if secret is set (config and GET parameter).
    if (!isset($_GET["secret"])) {
        handle_error("No secret as GET parameter given.");
    }

    # Compare given secrets
    if (strcmp($secret, htmlspecialchars($_GET["secret"])) == 0) {
        print_bold("Authentication sucessfull!");
    } else {
        handle_error("Authentication failed!");
    }
}

/**
 * Run git fetch and git checkout in the local repository.
 *
 * The changes for the specified branch will be fetched and the branch checked
 * out.
 *
 * @param string $local_path path of the local repository
 * @param string $branch branch name that should be checked out
 *
 * @return void
 */
function git_pull($local_path, $branch)
{
    if (is_writable($local_path . "/.git")) {
        # Switch to local repository
        chdir($local_path);

        # Fetch changes for pre-configured branch
        print_bold("Fetching " . $branch . " branch.");
        exec("git fetch --progress origin " . $branch . " 2>&1", $output, $return_var);
        print_git_output($output);
        handle_status($return_var, "Fetching");

        # Switch to pre-configured branch
        print_bold("Switching to " . $branch . " branch");
        exec("git checkout --progress " . $branch . " 2>&1", $output, $return_var);
        print_git_output($output);
        handle_status($return_var, "Checkout");
    } else {
        handle_error("No .git directory found, but directory already exists.");
    }
}

/**
 * Run git clone in the local path.
 *
 * If the git repository is not yet created the given branch will be cloned.
 *
 * @param string $local_path Path of local repository
 * @param string $remote_path Path/URL of remote repository
 * @param string $branch Name of working branch
 *
 * @return void
 */
function git_clone($local_path, $remote_path, $branch)
{
    # Clone remote repository into local path
    print_bold("Repository doesn't exists. Trying to clone.");
    exec("git clone --progress --branch=" . $branch . " " . $remote_path . " " . $local_path . " 2>&1", $output, $return_var);
    print_git_output($output);
    handle_status($return_var, "Cloning");
}

/**
 * Main entry function.
 *
 * @return void
 */
function main()
{
    # Preparations
    $config = parse_config();
    verify_config($config);
    authenticate($config["secret"]);

    # Actual deploy operations
    if (is_writable($config["local-path"])) {
        git_pull($config["local-path"], $config["branch"]);
    } elseif (is_writable(dirname($config["local-path"]))) {
        git_clone($config["local-path"], $config["remote-path"], $config["branch"]);
    } else {
        handle_error("Path doesn't exists, can't created or is not writable");
    }
}

main();
