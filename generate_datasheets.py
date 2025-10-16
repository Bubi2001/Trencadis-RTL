# generate_datasheets.py
# This script is intended to be run from within the 'doc/' directory.

import os
import re
from pathlib import Path
import markdown2
from weasyprint import HTML, CSS

# --- Configuration ---
# Define the project's root directory (which is one level up from this script)
PROJECT_ROOT = Path(__file__).parent.parent.resolve()

# Define the paths for your documentation directories, relative to the project root
DOCS_DIR = PROJECT_ROOT / "doc"
MD_DATASHEETS_DIR = DOCS_DIR / "datasheets_md"
PDF_DATASHEETS_DIR = DOCS_DIR / "datasheets_pdf"
ASSETS_DIR = DOCS_DIR / "assets"

# --- Styling (CSS for MkDocs Material 'Teal' Theme) ---
STYLESHEET = """
    @page {
        size: A4;
        margin: 1in;
        @bottom-right {
            content: "Page " counter(page) " of " counter(pages);
            font-size: 9pt;
            color: #757575; /* A muted grey for the footer */
        }
    }
    body {
        font-family: "Roboto", -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
        line-height: 1.6;
        color: #333;
        font-size: 11pt;
    }
    h1, h2, h3, h4 {
        font-weight: 400;
        color: #004D40; /* Dark Teal for headings */
        margin-top: 1.5em;
        margin-bottom: 0.8em;
    }
    h1 {
        font-size: 26pt;
        text-align: center;
        border-bottom: 2px solid #009688; /* Primary Teal color */
        padding-bottom: 10px;
        margin-bottom: 1em;
    }
    h2 {
        font-size: 20pt;
        border-bottom: 1px solid #B2DFDB; /* Lighter Teal for sub-borders */
        padding-bottom: 5px;
    }
    h3 {
        font-size: 16pt;
    }
    hr {
        border: none;
        border-top: 1px solid #e0e0e0;
        margin: 2.5em 0;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 1.2em;
        font-size: 10pt;
        table-layout: fixed; /* Prevent tables from expanding uncontrollably */
    }
    th, td {
        border: 1px solid #ddd;
        padding: 8px 12px;
        text-align: left;
        overflow-wrap: break-word; /* Force long words to wrap */
        word-wrap: break-word; /* For older browsers */
    }
    th {
        background-color: #E0F2F1; /* Light Teal for table headers */
        font-weight: bold;
        color: #004D40;
    }
    pre {
        background-color: #f5f5f5;
        border: 1px solid #e0e0e0;
        border-radius: 4px;
        padding: 1em;
        white-space: pre-wrap;
        word-wrap: break-word;
        font-size: 9.5pt;
    }
    code {
        font-family: "Roboto Mono", "Courier New", Courier, monospace;
        background-color: #e0f2f1;
        color: #00796b;
        padding: 2px 5px;
        border-radius: 3px;
        font-size: 0.9em;
        word-break: break-all;
    }
    pre code {
        background-color: transparent;
        color: inherit;
        padding: 0;
        border-radius: 0;
        word-break: normal;
    }
    a {
        color: #009688;
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }
    img {
        display: block;
        margin-left: auto;
        margin-right: auto;
        max-width: 95%;
        margin-top: 1em;
        margin-bottom: 1em;
    }
"""

def format_title(markdown_text):
    """
    Finds the datasheet title and reformats it using regex.
    From: # Datasheet: trencadis_module_name
    To:   # Datasheet: Trencadís Module Name
    """
    pattern = r'(# Datasheet: )(trencadis_[\w]+)'
    match = re.search(pattern, markdown_text)
    if match:
        original_prefix = match.group(1)
        module_name_snake = match.group(2)
        formatted_name = module_name_snake.replace('trencadis_', 'Trencadís ') \
                                          .replace('_', ' ') \
                                          .title()
        new_title_line = f"{original_prefix}{formatted_name}"
        return markdown_text.replace(match.group(0), new_title_line)
    return markdown_text

def convert_markdown_to_pdf(md_path, pdf_path):
    """
    Converts a single Markdown file to a PDF with styling.
    """
    print(f"🔄 Converting {md_path.relative_to(PROJECT_ROOT)}...")
    with open(md_path, 'r', encoding='utf-8') as f:
        md_content = f.read()

    md_content = format_title(md_content)

    html_body = markdown2.markdown(
        md_content,
        extras=["tables", "fenced-code-blocks", "no-intra-word-emphasis"]
    )
    
    html_body = html_body.replace('src="assets/', f'src="{ASSETS_DIR.relative_to(PROJECT_ROOT)}/')
    html_body = html_body.replace('src="doc/assets/', f'src="{ASSETS_DIR.relative_to(PROJECT_ROOT)}/')

    full_html = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto|Roboto+Mono">
        <style>{STYLESHEET}</style>
    </head>
    <body>
        {html_body}
    </body>
    </html>
    """

    pdf_path.parent.mkdir(parents=True, exist_ok=True)
    html = HTML(string=full_html, base_url=str(PROJECT_ROOT))
    html.write_pdf(pdf_path)

    print(f"✅ Success! Saved to {pdf_path.relative_to(PROJECT_ROOT)}")


def main():
    """
    Main function to find and convert all Markdown datasheets.
    """
    print("--- Starting Datasheet Generation (Material Theme) ---")
    if not MD_DATASHEETS_DIR.exists():
        print(f"❌ Error: Input directory not found at '{MD_DATASHEETS_DIR}'")
        return

    md_files = list(MD_DATASHEETS_DIR.rglob("*.md"))
    if not md_files:
        print("🤷 No Markdown files found to convert.")
        return

    for md_file_path in md_files:
        relative_path = md_file_path.relative_to(MD_DATASHEETS_DIR)
        pdf_file_path = PDF_DATASHEETS_DIR / relative_path.with_suffix(".pdf")
        try:
            convert_markdown_to_pdf(md_file_path, pdf_file_path)
        except Exception as e:
            print(f"❌ Error converting {md_file_path}: {e}")
        print("-" * 20)

    print("--- All Datasheets Generated Successfully! ---")


if __name__ == "__main__":
    main()
