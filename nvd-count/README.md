# Tracking Vulnrichment status

This is a set of utilities you can run to get a sense of how far along the Vulnrichment project is when it comes to covering the CVEs that NVD has yet to analyze.

## Setting up

First, you will want to clone these two GitHub repositories next to each other:

```bash
git clone https://github.com/fkie-cad/nvd-json-data-feeds.git
git clone https://github.com/cisagov/vulnrichment.git
```

Once you've got all that, and assuming you have a sensible shell like [ZSH](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH), you should be good to go.

## Running things

On a typical run, you'll want to first make sure everything's up to date in both teh NVD JSON
feed repo and the Vulnrichment repo, then start counting things. This is all contained in
`daily-check.sh`, which should run about once a day. That will write to [stats.md](stats.md)
and [daily-stats.csv](daily-stats.csv)

The whole run takes maybe an hour or so to complete, since we recount every CVE that the NVD
JSON data knows about.

While this is all written in some pretty amateur shell scripting, it has the upside of being
fairly easy to follow if you want to make something better.
