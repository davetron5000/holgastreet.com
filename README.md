# holgastreet.com

Static Site Generator for [holgastreet.com](holgastreet.com).

## How This Works

The files in `original_images` are expected to have EXIF data set so that we can tell what roll they are a part of and all that other
stuff.  The images are the database.  The only data *not* in the images is in `rolls.json`, which contains metadata about a given roll.

So the basic workflow is:

1. Scan the negatives
1. Crop/Fix them and save to a folder here (*not* `original_images`).  Give the files descriptive and unique names. This will be in the URLs on the site
1. Create a script to add the metadata to them using `exe/set_image_metadata` using `-o original_images`
   1. Provide any values common to all the pictures, such as date or GPS
   1. Redirect that into a file
   1. Edit that file to provide titles/descriptions per picture
   1. If you need lat/long look it up via https://www.latlong.net/convert-address-to-lat-long.html
   1. execute that file as a script
1. When that's done, `bundle exec rake site` will process them and create the static site in `site`
1. `bundle exec rake serve` will serve it locally
1. `bundle exec rake deploy` will deploy to AWS

## Scanning Notes

* Scan at 3000+ DPI
* For Holga film, Descreening, Backlight Correction, and Unsharp Mask do absolutely nothing.
