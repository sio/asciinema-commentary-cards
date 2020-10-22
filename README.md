# Record asciicast with commentary cards

The Makefile in this repo helps to record an asciicast while displaying
prerecorded commentary cards. This saves time and embarassment of typos while
trying to explain what's going on in the recorded terminal.


## Usage

1. Create commentary cards

   Write plain text files and put them into `cards/` directory. Lexical
   filename order will define the sequence in which these cards will be shown.
   Do not use spaces in your filenames, it's GNU Make after all!

2. `make prepare`

   This recipe will create a new Tmux session with two panes: one for cards
   and the other for your screencast. Read usage instructions on the first
   card and prepare screencast environment (cd to correct directory, launch a
   program if you need, etc). When you're ready, detach from Tmux session
   (Ctrl+]).

3. `make record`

    Start recording within Tmux session we've just set up. Use Ctrl+Space to
    change to the next card, Ctrl+] to detach from Tmux and stop recording.

4. `make play`

    View the screencast you just recorded.

5. `make destroy`

    End Tmux session that was created for the screencast


## Configuration

Some environment variables may be used to fine tune the process:

- `OUTPUT` - Path to save the asciicast file. Default value is based on Unix
  timestamp: "rec-`date +%s`.asciicast`
- `ASCIINEMA` - Path to asciinema executable. Default: "asciinema"
- `CARD_PANE_HEIGHT` - Height of cards pane. Default value is calculated to
  fit all lines from your largest card
- `REC_IDLE_LIMIT` - Limit recorded terminal inactivity to this number of
  seconds


## Support and contributing

If you need help with using this Makefile or including it into your project,
please create **[an issue][issues]**.
Issues are also the primary venue for reporting bugs and posting feature
requests. General discussion related to this project is also acceptable and
very welcome!

In case you wish to contribute code or documentation, feel free to open
**[a pull request][pulls]**. That would certainly make my day!

I'm open to dialog and I promise to behave responsibly and treat all
contributors with respect. Please try to do the same, and treat others the way
you want to be treated.

If for some reason you'd rather not use the issue tracker, contacting me via
email is OK too. Please use a descriptive subject line to enhance visibility
of your message. Also please keep in mind that public discussion channels are
preferable because that way many other people may benefit from reading past
conversations. My email is visible under the GitHub profile and in the commit
log.

[issues]: https://github.com/sio/asciinema-commentary-cards/issues
[pulls]:  https://github.com/sio/asciinema-commentary-cards/pulls


## License and copyright

Copyright 2020 Vitaly Potyarkin

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
