# Job Search Automation via a Recommender Engine and Machine Learning

  Employment processes can be very frustrating and time consuming. The average candidate spends months surfing the web for his/her dream job. He/she sends hundreds of applications while receiving very few or no feedback. On the other hand, employers/recruiters receive thousands of applications from qualified as well as unqualified candidates per job post. There are many job posting boards such as LinkedIn, Indeed, CareerBuilder, and Glassdoor that exist today, making employment processes more sophisticated. Employers might post on none or some of these boards, but not on others. This, in turn, forces job seekers to visit more boards to search and apply for jobs. Having been job seekers at some point in our lives, we know what it is like to be a job seeker. We understand the stress, and the patience that come with it. Therefore, we are aiming to simplify and accelerate such processes. Our motivation is to automate job searches in order to increase the efficiency of employment processes for both job seekers and employers. An efficient employment process leads to more employment, less applications, less time, and less effort. This also means that only interesting and matching job posts will be recommended to job seekers, and only qualified candidates will apply to specific jobs.

  This project is done as part of the Data Science Seminar, DATA 5000, at Carleton University for the winter term of the 2018-2019 academic year. Our goal is to design a website that gathers information from the various job posting boards through Application Programming Interfaces (APIs) and uses machine learning to recommend jobs to job seekers. The four main objectives of this pilot project are to:

1. collect, process, and analyse data;
2. build a recommender engine that sifts through the users’ applications history to recommend jobs;
3. implement a machine learning algorithm to optimize the results of job searches; and
4. develop a website to enable job seekers to view posts from multiple job posting boards in one place.

Finally, we will validate and verify our work by testing the website.

  In terms of the data set, our data consists of information about jobs, users, and organizations. More specifically, we used the data set from [1], which consists of 19,000 online job posts that were posted through the Armenian human resource portal, CareerCenter, from 2004 to 2015. We also started collecting our own candidates data through a GoogleForms survey at https://goo.gl/forms/M0NqNlGewpHyKJD63. We processed and visualize the data from both sources in RStudio. Another dynamic source of data is the recommender system, which will generate user profiles by collecting data from candidate actions such as job views and/or applications. Initially, the recommender system depends on the original data set along with basic user information, such as skills and interests, to create matches and recommend jobs. It will then utilize a machine learning algorithm to find similarities and affinities between job posts and candidate profiles. Lastly, the jobs that match the profile of the candidate will be recommended to him/her.

  Due to time constraints, the website might not be fully functioning or published by the end of the term (i.e. April 2019), and it will only use the APIs from very few job posting boards. Going forward, we will keep building up on the website to make it public. Also, the implemented machine learning algorithm will be trained on a list of past job offers to predict which job applications are likely to lead to job offers. This should further optimize the recommendations and enhance the classification performance.

## To run the code:- 
1. Install R
2. Download RStudio
3. Download the files from this repository
4. Open the files in RStudio
5. To visualize the data, run all chuncks in the dataVisualizationAndExploration.Rmd module
6. To analyze the data using unsupervised and supervised learning, run all chuncks in the dataAnalysis.Rmd module
7. To view sample results of our data analysis, run all chunks in the resultsEvaluationAndValidation.Rmd module

## References
[1] Hab, M. (2017, April 22). Online Job Postings. Retrieved March 2, 2019, from
https://www.kaggle.com/madhab/jobposts.
