# Frequently asked questions

These questions are for contributors to answer the most common questions, that they raise when integrating a data source.

## Programming

> What language should I use?

COVID19 is R package, for processing of the data source you should use R. However for collection of the slowly-changing variables (population etc.) you may use whatever language is your favorite.

## Data in general

> Some days are missing. Is it better to leave NAs or remove those?

If you have NAs in some variables only, you can not remove the line, because you would loose data. But if the whole line is empty, drop it. Our library will take care of missing dates afterwards.

## Regional data

> Among regions there is group of unassigned data. What should I do with it?

Drop it. We address regional data by id of region, which should not be undefined. Hence there is no way how to handle them.


