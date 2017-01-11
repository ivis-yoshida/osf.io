from website import settings
from website.project import utils


def activity():
    """Reads node activity from pre-generated popular projects and registrations.
    New and Noteworthy projects are set manually or through `scripts/populate_new_and_noteworthy_projects.py`
    Popular projects and registrations are generated by `scripts/populate_popular_projects_and_registrations.py`
    """
    # Prevent circular import
    from osf.models import AbstractNode as Node

    # New and Noreworthy Projects
    try:
        new_and_noteworthy_pointers = Node.load(settings.NEW_AND_NOTEWORTHY_LINKS_NODE).nodes_pointer
        new_and_noteworthy_projects = [pointer.node for pointer in new_and_noteworthy_pointers]
    except AttributeError:
        new_and_noteworthy_projects = []

    # Popular Projects
    try:
        popular_public_projects = Node.load(settings.POPULAR_LINKS_NODE).nodes_pointer
    except AttributeError:
        popular_public_projects = []

    # Popular Registrations
    try:
        popular_public_registrations = Node.load(settings.POPULAR_LINKS_REGISTRATIONS).nodes_pointer
    except AttributeError:
        popular_public_registrations = []

    return {
        'new_and_noteworthy_projects': new_and_noteworthy_projects,
        'recent_public_registrations': utils.recent_public_registrations(),
        'popular_public_projects': popular_public_projects,
        'popular_public_registrations': popular_public_registrations,
    }
