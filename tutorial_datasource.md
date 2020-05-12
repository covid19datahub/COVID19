### Find the data

##### Which data-sources are eligible?

- Level 1: Official, complete, fast-updating. 
- Level 2: Official, complete, fast-updating. If missing, well-documented and well-structured sources are temporary good 
- Level 3: We prioritize Official, complete, fast-updating data. If missing well-documented and well-structured sources are good.

To have a better idea, check out the [sources](https://github.com/covid19datahub/COVID19dev/tree/master/R) that have already been implemented.

##### How to find an eligible data-source?

- Check our list [of data-sources](https://github.com/covid19datahub/COVID19/blob/master/TODO.md) that have yet to be integrated 

- Look for a new data-source! Check out these [suggestions](https://covid19datahub.slack.com/archives/C012XQVAQ2W) on where to start looking.

  

### Write the function

Create a new `ds_*` file, named with the domain of the data source, that does the followings:

- **Load** the COVID19 and (if any) other required packages

- **Download** the data and store it in a variable called  `x`

- **Rename** the columns according to our format: `id, date, tests, confirmed, deaths, recovered, hosp, vent, icu` . 
  Remember that only the column `date` is required, all the others could be dropped if the data is missing

- **Format** the data correctly. Most importantly, `date` should be of the format date.
- **Clean** your data! This could include operation such as:
  - Imposing NAs on values different than NA and numeric
  - Dropping non-useful columns
  - Fixing encoding issues
  - ...
- **Filter** your data, based on the function input `level`*(Required only if your data contains more than one level)*

- **Return** the result

Remember that your function must have the parameter `cache` as a first element, and the others (`level`, ...) could be in random order.

The utilities that you can find [here](https://covid19datahub.io/reference/) could be very useful!



### Test the function and the data

In order to test if your function is working, try answering the following questions.

- Is the function returning a data-frame with correct column names?
- Is the data coherent with the original source?
- Is the data coherent with other sources? *(fast trick, google COVID19 + iso)*
- Is the function working properly with all the possible levels?



### Create a pull request

Once you created the function and passed the tests, you're ready for the pull request!

- **Fork** the repository
- **Propose** a new file in the R folder. 
- **Call** the file with the name of your function. Don't forget the .R extension!
- **Summarize** in the description what is your file doing. *(Es: France level 1,2,3 data from official source)*
- **Ask** for the pull request! You'll receive a comment in a short period of time.



If you followed the instructions up to here, your request will most likely be accepted right away. However, there could be some comments by the admins:

In that case:

- **Download** the changed file. You can find it inside your pull request
- **Modify** what the administrator asked you
- **Create** the pull request again
