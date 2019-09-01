# holgastreet.com

Static Site Generator for [holgastreet.com](holgastreet.com).

## To use

1. Scan images at 3600DPI
1. `bundle exec rake prep[«rollname»]` (rollname usually a date)
1. To get lat/long go to https://www.latlong.net/convert-address-to-lat-long.html
1. `bundle install`
1. Export images from Photos to `original_images/`
1. `bundle exec rake`
1. Deploy `site`
