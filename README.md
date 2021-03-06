# doc-as-code-example
A CI/CD example of documentation management as  Infrastructura-as-code


# Requirements

* Python 3.4
  * [pyenv](https://github.com/yyuu/pyenv)
  * [pyenv-virtualenv](https://github.com/yyuu/pyenv-virtualenv)
* Jenkins 2.x

# Setup

```
# pyenv 
pyenv install 3.4.3
pyenv virtualenv 3.4.3 py34.doc-as-code
pyenv local py34.doc-as-code

pip install -r requirements/prd.txt

# initiallize submodule
git submodule update

```

# Operations

```
# Add a documentation project as git submodule 
git submodule add https://github.com/manboubird/sphinx-doc-example.git ./docs/sphinx-doc-example

```

Mkdocs document project creation
```
mkdocs new docs/mkdocs-example
cd docs/mkdocs-example

# live editing
mkdocs serve

# live editing
mkdocs serve

# build documentation and confirm build html with http server
mkdocs build
python -m http.server
open http://localhost:8000/site
```

Sphinx document project creation
```
sphinx-quickstart docs/sphinx-example
cd docs/sphinx-example

# Insert live editing into Makefile
cat <<EOF >> Makefile

livehtml:
	sphinx-autobuild -b html \$(ALLSPHINXOPTS) \$(BUILDDIR)/html
	@echo
	@echo "live html editing finished."
EOF
# start live edting
make livehtml

# build documentation and confirm build html with http server
make html
python -m http.server
open http://localhost:8000/_build/html
```

Bump version
```
# list bump-version without any update
bumpversion --dry-run --allow-dirty --list major

# bump major version
bumpversion --allow-dirty --list major

#
# Bumpveion with commit and tag creation options.
# commit and tag configuraitons should be True in .bumpversion.cfg
#

# update release notes for preparing bumping version
vim release-note-file

# commit the release note 
git add release-note-file
git ci -m "prep. for bumpversion"

# bumpversion with commit and tag creation
bumpversion --list major

# push bumpversion commit
git push origin

# push new tags created by bumpversion
git push origin --tags

```

