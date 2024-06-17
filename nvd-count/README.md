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

## Interpreting results

When reading [daily-stats.csv](daily-stats.csv), you will notice several columns. Those are:

* Date: The date that row was completed. Usually, but not always, based on Central US time.

For the NVD lists of CVEs:

* NVD-Awaiting: The total number of CVEs marked as "Awaiting Analysis" by the NVD. These are CVEs that, as you might expect, have not undergone analysis by the NVD yet.
* NVD-Analyzed: The total number of CVEs marked as "Analyzed" by the NVD. Those that have reached the end of analysis at NVD.
* NVD-Modified: The total number of CVEs marked as "Modified" by the NVD. Those that were once analyzed by the NVD, but the CVE has since changed, possibly in a material way.
* NVD-Rejected: The total number of CVEs marked as "Rejected" by the NVD. No futher information should be expected on those, as the CVEs are unpublished.
* NVD-Other: The total number of CVEs marked as some other status, usually "In Progress." Not analyzed, but not-not analyzed?

For the ADP lists of CVEs:

* ADP-Done: The total number of CVEs that have a CISA ADP container that are also on the NVD-Awaiting list.
* ADP-Extra: The total number of CVEs that have a CISA ADP container that are NOT on the NVD-Awaiting list. Ususally, these are on the NVD-Analyzed list, but might be NVD-Modified or NVD-Other.
* ADP-TODO: The total number of CVEs that are missing a CSA ADP container, that are also on NVD-Awaiting list.
