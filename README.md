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

# initiallize submodule
git submodule update

```

# Operations

```
# Add a documentation project as git submodule 
git submodule add https://github.com/manboubird/sphinx-doc-example.git ./docs/sphinx-doc-example

```
