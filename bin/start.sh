#!/bin/bash

bundle exec rake db:migrate
bundle exec puma -p 80