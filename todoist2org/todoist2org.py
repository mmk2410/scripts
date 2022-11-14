"""Playground application for working with the todoist api."""
import os
from datetime import datetime
from todoist_api_python.api import TodoistAPI
from tqdm import tqdm
from dotenv import load_dotenv

# API Documentation: https://developer.todoist.com/rest/v2/?python#tasks
# Perhaps helpful: https://github.com/novoid/orgformat

counter = {
    'projects': 0,
    'tasks': 0,
    'sections': 0,
    'comments': 0
}


def get_filename(project_name, extension=True):
    """Create a filename from a project name."""
    filename = project_name.replace(" ", "-")
    filename = filename.replace("/", "")
    filename = filename.replace("--", "-")
    filename = filename.lower()
    if extension:
        filename += ".org"
    return filename


def create_output_dir():
    """Create the output dir if it doesn't exist."""
    output_dir = os.environ.get("OUTPUT_DIR", "./output")
    if not os.path.exists(output_dir):
        os.mkdir(output_dir)


def write_file(path, content):
    """Write a org mode file."""
    outputFile = open(path, "w")
    outputFile.write("\n".join(content))
    outputFile.close()


def parse_comments(task_id):
    """Parse comments of a task."""
    output = []
    comments = api.get_comments(task_id=task_id)
    counter['comments'] += len(comments)

    output.append("*** Comments")

    for comment in comments:
        output.append(f" - {comment.content}")
        if comment.attachment:
            output.append(f"   Attachment: {comment.attachment.file_url}")

    return output


def parse_task(task, subtask):
    """Print a task."""
    output = []
    if subtask:
        headline = f"**** TODO {task.content}"
    else:
        headline = f"** TODO {task.content}"

    labels = task.labels
    if len(labels) > 0:
        headline += " :" + ":".join(labels) + ":"

    output.append(headline)

    if task.due:
        if task.due.datetime:
            dueDate = datetime.strptime(
                task.due.datetime,
                "%Y-%m-%dT%H:%M:%S"
            )
            formattedDueDate = dueDate.strftime("<%Y-%m-%d %a %H:%M>")
            due = f"SCHEDULED: {formattedDueDate}"
            output.append(due)
        elif task.due.date:
            dueDate = datetime.strptime(task.due.date, "%Y-%m-%d")
            formattedDueDate = dueDate.strftime("<%Y-%m-%d %a>")
            due = f"SCHEDULED: {formattedDueDate}"
            output.append(due)

        humanDue = (f"*Due: {task.due.string}*")
        if task.due.is_recurring:
            humanDue += " (recurring)"

        output.append(humanDue)
        output.append("")

    createdDate = datetime.strptime(
        task.created_at,
        "%Y-%m-%dT%H:%M:%S.%fZ"
    )
    formattedCreatedDate = createdDate.strftime("[%Y-%m-%d %a %H:%M]")
    output.append(f"CREATED: {formattedCreatedDate}")

    if task.description:
        output.append(task.description)

    if task.comment_count > 0:
        output.extend(parse_comments(task.id))

    output.append("")
    return output


def parse_sections(project_id, tasks):
    """Print a section."""
    output = []
    sections = api.get_sections(project_id=project_id)
    counter['sections'] += len(sections)

    for section in sections:
        output.append(f"* {section.name}")
        output.append("")
        subtask = False
        for task in tasks:
            if task.section_id == section.id:
                if not subtask and task.parent_id:
                    output.append("*** Subtasks")
                    subtask = True
                if subtask and not task.parent_id:
                    subtask = False
                output.extend(parse_task(task, subtask))

    return output


def parse_project(project, parent_project_name=""):
    """Parse a project."""
    filename = get_filename(project.name)
    content = []

    output_dir = os.environ.get("OUTPUT_DIR", "./output")

    if parent_project_name and project.parent_id:
        content.append(f"#+title: {parent_project_name}: {project.name}")
        parent_filename = get_filename(parent_project_name, False)
        path = f"{output_dir}/{parent_filename}_{filename}"
    else:
        content.append(f"#+title: {project.name}")
        path = f"{output_dir}/{filename}"

    if not project.parent_id:
        parent_project_name = project.name

    content.append("#+startup: indent overview")
    content.append("")
    content.append("* Normal Tasks")
    content.append("")

    tasks = api.get_tasks(project_id=project.id)
    counter['tasks'] += len(tasks)

    subtask = False
    for task in tasks:
        if not task.section_id:
            if not subtask and task.parent_id:
                content.append("*** Subtasks")
                subtask = True
            if subtask and not task.parent_id:
                subtask = False
            content.extend(parse_task(task, subtask))

    content.extend(parse_sections(project.id, tasks))

    write_file(path, content)
    return parent_project_name


def print_stats():
    """Print some useless stats at the end."""
    output = "Retrieved, parsed and stored"
    output += f" {counter['projects']} projects,"
    output += f" {counter['sections']} sections,"
    output += f" {counter['tasks']} tasks, and"
    output += f" {counter['comments']} comments."
    print(output)


def parse_projects():
    """Parse the list of projects."""
    try:
        print("Retrieving list of projects to start parsing.")
        projects = api.get_projects()
    except Exception as error:
        print(error)

    counter['projects'] = len(projects)

    parent_project_name = ""
    for project in tqdm(projects, "Parsing Projects"):
        parent_project_name = parse_project(project, parent_project_name)


def main():
    """Run the program."""
    load_dotenv()
    global api
    api = TodoistAPI(os.environ.get("TOKEN", ""))
    create_output_dir()
    parse_projects()
    print_stats()


if __name__ == "__main__":
    main()
