# MomokoDict

MomokoDict is a simple Japanese-English dictionary.

It uses JMDict (via [jmdict-simplified](https://github.com/scriptin/jmdict-simplified)) as the data source and Flutter as the UI engine.

Currently MomokoDict supports the common entries version of the dictionary only. Using a full distribution may crash the program due to technical limitations of this project.

## Compiling

1. Download the source code of this project.

2. Download and extract [`jmdict-eng-common-3.1.0.json`](https://github.com/scriptin/jmdict-simplified/releases/download/3.1.0%2B20201001122454/jmdict-eng-common-3.1.0+20201001122454.json.zip) (or any compatible later versions) into the `assets` folder.

3. Compile.

## Acknowledgment

[Jim Breen's JMdict Japanese-English dictionary](https://www.edrdg.org/), by Jim Breen and the Electronic Dictionary Research and Development Group.

[Jmdict-simplified](https://github.com/scriptin/jmdict-simplified), by Dmitry Shpika.

## License

The source code of this project is licensed under GPLv3.

The JMDict dictionary used by this project has its own license, see [the Electronic Dictionary Research and Development Group's License Statement](https://www.edrdg.org/edrdg/licence.html).
