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

On a typical run, you'll want to first make sure everything's up to date, then bop through the provided scripts.
Assuming you're starting in this README.md's directory, it should go something like this:

```bash
git -C ../../nvd-json-data-feeds fetch &&
git -C ../../nvd-json-data-feeds pull -r &&
./nvd-count.sh &&
./adp-count.sh &&
./count-complete-and-todo-cves.sh | tee stats.md
```

This will read all the CVE data from both the NVD JSON data feed, the Vulnrichment repo, and then figure out which are done and how many there's left to do.

The whole run takes maybe an hour or so to complete, the vast majority of the time taken by crawling the entire NVD CVE corpus (`nvd-count.sh`). In the end, you'll have a bunch of raw data to mess around with, as well as a `stats.md` summary file that looks like this:

```
Vulnrichment has covered 6131 CVEs, with 6910 left to do.
Vulnrichment has covered 47% of the 13041 still to be analyzed by NVD.
```

While this is all written in some pretty amateur shell scripting, it has the upside of being fairly easy to follow if you want to make something better.
