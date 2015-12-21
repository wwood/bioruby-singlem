# bio-singlem

[![Build Status](https://secure.travis-ci.org/wwood/bioruby-singlem.png)](http://travis-ci.org/wwood/bioruby-singlem)

Ruby interface to the [https://github.com/wwood/singlem](SingleM) program.

Note: this software is under active development!

## Installation

```sh
gem install bio-singlem
```

## Usage

```ruby
require 'bio-singlem'

table = Bio::SingleM::Runner.pipe(['/path/to/sequences.fq.gz'], :threads => 30)
 #=> Bio::SingleM::OtuTable
 
table.otus[0].taxonomy #=> "Root; d__Bacteria; p__Chloroflexi"
```

The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/wwood/bioruby-singlem

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

If you use this software, please cite SingleM (currently unpublished).

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-singlem)

## Copyright

Copyright (c) 2015 Ben J Woodcroft. See LICENSE.txt for further details.

