TwitMap

Created a Google App Engine based TwittMap, something close to, http://worldmap.harvard.edu/ tweetmap/

1. Collected about 100MB tweets using Twitter API from GAE application
2. Parsed the Tweets and store in Datastore. The parsed twits have location information and a set of key words from the content of the tweets. 
3. Created a scatter plot that depicts all the tweets with a the density map - with color gradient etc. 
4. Provided a filter that allows a drop down keywords to choose from and only shows tweets with those keywords on a google map.
5. Memcache was used for already seen queries.
6. Created a timeline - meaning with progression of days, tweet map should be rendered. 
7. Every midnight, get new tweets and replot, using scheduled task service.
8. Created a mobile interface.
9. Showed timeline in an innovative way to see the twit trends.
10.Has a dynamic keyword dictionary from the analysis of twit contents.
=======
