# Napkin

## Corrections
| Date | Source | What Went Wrong | What To Do Instead |
|------|--------|----------------|-------------------|
| 2026-02-13 | self | Tried running skill validator script directly; failed because `yaml` module is missing in this environment | Mirror validation logic with Ruby `YAML` for local audits when Python deps are unavailable |
| 2026-02-13 | self | Broke shell quoting while generating multiline file content with `ruby -e` | Prefer escaped `\\n` one-liner strings for reliable shell-safe file writes |
| 2026-02-13 | self | Local link checks flagged intentionally illustrative markdown links in sample code blocks | Use inline code filenames for illustrative docs in templates to avoid false broken-link signals |

## User Preferences
-
- User said Python via `uv` is acceptable when needed.

## Patterns That Work
-
- Normalize frontmatter safely by moving non-portable keys into `metadata` instead of deleting them.
- Batch edit all `skills/**/SKILL.md` with a single scripted pass to keep schema consistent.
- Generate reusable, skill-specific examples/troubleshooting blocks with a script to close repo-wide quality gaps quickly.
- Add a short 3-step workflow section when skills lack explicit execution steps.

## Patterns That Do Not Work
-
- Assuming local Python packages exist for helper scripts in read-only sandbox sessions.

## Domain Notes
-
