# Legal Disclaimer Generator (Rails + Turbo + OpenAI)

This is a demo Rails app that generates legal disclaimers using the OpenAI API.
It uses Turbo Streams to dynamically update the UI with freshly generated disclaimers.

## Features

- User form with disclaimer topic + optional tone
- Turbo stream-based dynamic updates
- Partial rendering for snappy UX
- OpenAI API integration (GPT-4o)

## Setup

```bash
cp .env.example .env
# Add your OpenAI token to the new .env file
bundle install
rails server
```
