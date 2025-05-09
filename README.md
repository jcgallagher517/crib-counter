# Cribbage Counter

Simple program to count a hand in the wonderful game of cribbage.
There are two front-end options: A CLI script and a local web application.

The script is located in `bin/crib-counter.rb`.

You can run the web application by navigating to `web` and running `ruby server.rb`.
This will start the server on port 3000, so navigate to `localhost:3000` in your browser.

The input fuzzily accepts inputted cards, meaning that "5 Hearts", "5 h", and "5 hea" will all match to the same card.
