# holgastreet.com

Static Site Generator for [holgastreet.com](holgastreet.com).

## How This Works

The files in `original_images` are expected to have EXIF data set so that we can tell what roll they are a part of and all that other
stuff.  The images are the database.  The only data *not* in the images is in `rolls.json`, which contains metadata about a given roll.

So the basic workflow is:

1. Scan the negatives
1. Crop/Fix them and save to a folder here (*not* `original_images`)
1. Add the metadata to them using `exe/set_image_metadata` using `-o original_images`
1. You will need to look up the lat/long via https://www.latlong.net/convert-address-to-lat-long.html
1. When that's done, `bundle exec rake site` will process them and create the static site in `site`
1. `bundle exec rake serve` will serve it locally
1. `bundle exec rake deploy` will deploy to AWS

## Scanning Notes

* Scan at 3000+ DPI
