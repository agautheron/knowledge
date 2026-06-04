import os
import sys

sys.path.append(os.path.abspath("./_ext"))

extensions = [
    "solution",
    "sphinxcontrib.katex",
    "sphinx_inline_tabs",
    "sphinx_math_dollar",
    "sphinx_togglebutton",
]

templates_path   = ["_templates"]
exclude_patterns = ["_build"]
html_static_path = ["_static"]
html_extra_path  = []

html_title       = "Knowledge"
html_theme       = "furo"
html_show_sphinx = False

html_theme_options = {
    "sidebar_hide_name": False,
    # Furo gère l'accordéon nativement, rien à ajouter
}

html_css_files = [
    "css/style.css",
    "css/courses.css",   # grille d'accueil + onglets sidebar
]

katex_css_path = "katex/katex.min.css"

katex_options = r"""macros: {
    "\\d": "\\operatorname{d}\\!",
    "\\dt": "\\d t",
    "\\vec": "\\overrightarrow",
}"""

import sphinx_math_dollar
replacer = sphinx_math_dollar.extension.MathDollarReplacer
replacer.visit_TabContainer = replacer.default_visit

# ---------------------------------------------------------------------------
# Navigation contextuelle par cours dans le bandeau gauche
# ---------------------------------------------------------------------------
# Chaque entrée associe un préfixe de chemin Sphinx à un label d'onglet
# et au chemin de l'index du cours.
# Pour ajouter un cours : une seule entrée à rajouter ici.
# ---------------------------------------------------------------------------
COURSES = {
    # slug (= préfixe exact du chemin Sphinx) : (label, chemin de l'index)
    "transfert_radiatif": (
        "Transfert Radiatif",
        "transfert_radiatif/index",
    ),
    "verilog_fpga": (
        "Verilog / FPGA",
        "verilog_fpga/index",
    ),
}


def _course_of_page(pagename: str) -> str | None:
    """Retourne le slug du cours auquel appartient pagename, ou None."""
    for slug in COURSES:
        # "transfert_radiatif" matche exactement "transfert_radiatif"
        # "verilog_fpga" matche "verilog_fpga/index", "verilog_fpga/02_syntaxe", etc.
        if pagename == slug or pagename.startswith(slug + "/"):
            return slug
    return None


def _html_page_context(app, pagename, templatename, context, doctree):
    """Injecte les variables de navigation dans chaque page Jinja2."""
    context["current_course"] = _course_of_page(pagename)
    context["course_labels"]  = {k: v[0] for k, v in COURSES.items()}
    context["course_roots"]   = {k: v[1] for k, v in COURSES.items()}


def setup(app):
    app.connect("html-page-context", _html_page_context)


# Sidebar furo : notre template remplace "sidebar-nav-bs.html"
html_sidebars = {
    "**": [
       "sidebar/navigation.html",
#        "search-field.html",
#        "course-nav.html",           # navigation contextuelle par cours
    ]
}
