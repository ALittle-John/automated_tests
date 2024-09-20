# automated_tests

This repository will be used to do automated tests with Robot Framework and Cypress over the same target. Duplicating the test for each syntax.

# Robot Framework

- Need to be installed where you want: `pip install robotframework`

### Setup environment

1. Install Robot Framework Language Server extention.
2. Enter the appropriate repository;

Terminal:

- `python -m venv venv` -> This will also create pyvenv.cfg with the python alias and more.
- `source venv/bin/activate`
- _To turn off the virtual enviroment use `deactivate` in terminal._

VsCode:

- Added the python venv option in "Python: Select Interpreter";
- setup.cfg was created to force vscode to use the correct venv to import lib.

With these steps, when you install a lib, pip uses the correct Python version set up in venv.

### requirements.txt

- **To install all dependencies use -> `pip install -r requirements.txt`**
- Using pipreqs -> `pip3 install pipreqs`
- _Create_ or update requirements.txt -> `pipreqs . --force`
  pipreqs lists just the libraries really used in the project where's called.

# Cypress

### Setup environment

1. Enter the appropriate repository;
- To cooperate, download the dependencies: `npm install`;
- Execute `npx cypress open` to execute visually the tests.
