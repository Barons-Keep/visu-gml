`visu-project` developer tools 
=============================


## Table of content
- [`visu-project` developer tools](#visu-project-developer-tools)
  - [Table of content](#table-of-content)
  - [Requirements](#requirements)
  - [Downloading tracks from a Git Repository](#downloading-tracks-from-a-git-repository)
    - [**Important Warning**](#important-warning)
    - [Summary](#summary)
  - [Run Tests](#run-tests)
  - [Logger](#logger)


## Requirements

To get started, install `gm-cli` (Node.js is required):

```shell
npm install -g @ovipakla/gm-cli@1.0.0
```


## Downloading tracks from a Git Repository

Please consider the following command:

```shell
gm-cli install
gm-cli run setup
```

`gm-cli install`: This downloads dependencies into the `gm_modules` folder according to the specified revisions in `package-gm.json`. To modify the revision for the track, change the relevant value to any available Git SHA:

```json
"track": {
  "remote": "https://github.com/Barons-Keep/visu-track.git",
  "revision": "INSERT_YOUR_GIT_REVISION"
}
```


`gm-cli run setup`: this command is a script defined in `package-gm.json`. You can create your own scripts by adding new entries to the `scripts` section:

```json
"scripts": {
  "setup": "./setup.sh",
  "setup-clean": "./setup.sh --clean",
  "log": "./log.sh"
}
```


### **Important Warning**

**BE CAREFUL**: This operation will remove the original `track` folder along with its contents. Ensure that you have a backup before executing `gm-cli run setup`.


### Summary

Whenever you want to override the `track` folder with new tracks from Git, then make sure you pushed your changes somewhere (#backup) and run the command

```shell
gm-cli install --clean
gm-cli run setup
```

---


## Run Tests

You can use the `test` command to execute all `*.test.json` suites:

```shell
gm-cli run test
```

It is also possible to execute a single test directly:

```shell
# Run a single test
./visu-project.exe --test="/path/to/test.json"

# Run multiple tests: comma-separated string
./visu-project.exe --tests="/path/1/test.json,/path/2/test.json"
```

---


## Logger

To save debug console output, use the following command:

```shell
./visu-project.exe --output="filename"
```

You can also use the dedicated `log` command:

```shell
gm-cli run log
```

This command will save the output to a separate file and start monitoring it in the terminal using `tail -f`.
