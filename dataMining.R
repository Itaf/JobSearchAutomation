#jobsData <- read.csv("Job Posts.csv")
#candidatesData <- read.csv("Job Search Questionnaire (Responses).csv")

candidateSamples <- split(candidatesData, candidatesData$Timestamp)
jobSamples <- split(jobsData, jobsData$job_id)

job_candidate <- matrix(0, nrow=length(candidateSamples)*length(jobSamples), ncol=9)
scores <- matrix(0, nrow=length(candidateSamples)*length(jobSamples), ncol=5)
response <- matrix(0, nrow=length(candidateSamples)*length(jobSamples), ncol=1)

index = 1

for(j in jobSamples)
{
  if(!is.na(j$jobpost)){j$jobpost <- tolower(j$jobpost)}
  if(!is.na(j$Title)){j$Title <- tolower(j$Title)}
  if(!is.na(j$Company)){j$Company <- tolower(j$Company)}
  if(!is.na(j$Term)){j$Term <- tolower(j$Term)}
  if(!is.na(j$Eligibility)){j$Eligibility <- tolower(j$Eligibility)}
  if(!is.na(j$Audience)){j$Audience <- tolower(j$Audience)}
  if(!is.na(j$JobDescription)){j$JobDescription <- tolower(j$JobDescription)}
  if(!is.na(j$JobRequirment)){j$JobRequirment <- tolower(j$JobRequirment)}
  if(!is.na(j$RequiredQual)){j$RequiredQual <- tolower(j$RequiredQual)}
  if(!is.na(j$ApplicationP)){j$ApplicationP <- tolower(j$ApplicationP)}
  if(!is.na(j$Notes)){j$Notes <- tolower(j$Notes)}
  if(!is.na(j$AboutC)){j$AboutC <- tolower(j$AboutC)}
  
  
  
  for(c in candidateSamples)
  {
    #FEATURE EXTRACTION
    c$Gender <- tolower(c$Gender)
    
    #gender match
    #if(grepl(c$Gender, j$jobpost, fixed=TRUE))
    #{
    #  job_candidate[index,1] <- 1
    #}
    #else
    #{
    #  job_candidate[index,1] <- 0.5
    #}
    
    
    
    ##EDUCATION
    c$Degree <- tolower(c$Degree)
    c$Degree <- strsplit(c$Degree,' ')
    
    ###degree percent match
    for(d in c$Degree[[1]])
    {
      if(grepl(d, j$jobpost, fixed=TRUE))
      {
        job_candidate[index,1] <- (job_candidate[index,1]) + 1
      }
    }
    job_candidate[index,1] <- (job_candidate[index,1])/(length(c$Degree[[1]]))
    
    
    
    if(!is.na(c$Major))
    {
      c$Major <- tolower(c$Major)
      c$Major <- strsplit(c$Major,' ')
      
      ###major percent match
      for(m in c$Major[[1]])
      {
        if(grepl(m, j$jobpost, fixed=TRUE))
        {
          job_candidate[index,2] <- (job_candidate[index,2]) + 1
        }
      }
      job_candidate[index,2] <- (job_candidate[index,2])/(length(c$Major[[1]]))
    }
    
    
    
    if(!is.na(c$Minor.Specialization))
    {
      c$Minor.Specialization <- tolower(c$Minor.Specialization)
      c$Minor.Specialization <- strsplit(c$Minor.Specialization,' ')
      
      ###minor/specialization percent match
      for(i in c$Minor.Specialization[[1]])
      {
        if(grepl(i, j$jobpost, fixed=TRUE))
        {
          job_candidate[index,3] <- (job_candidate[index,3]) + 1
        }
      }
      if(length(c$Minor.Specialization[[1]]) != 0)
      {
        job_candidate[index,3] <- (job_candidate[index,3])/(length(c$Minor.Specialization[[1]]))
      } 
    }
    
    
    
    ##AVAILABILITY
    c$Status <- tolower(c$Status)
    c$Status <- strsplit(c$Status,', ')
    
    ###need for a job
    for(s in c$Status[[1]])
    {
      if(grepl("student", s, fixed=TRUE))
      {
        job_candidate[index,4] <- job_candidate[index,4] + 0.5
      }
      else if(grepl("graduated", s, fixed=TRUE))
      {
        job_candidate[index,4] <- job_candidate[index,4] + 1
      }
      else if(grepl("not employed", s, fixed=TRUE))
      {
        job_candidate[index,4] <- job_candidate[index,4] + 1
      }
      else if(grepl("employed", s, fixed=TRUE))
      {
        job_candidate[index,4] <- job_candidate[index,4] + 0.25
      }
      else if(grepl("laid off", s, fixed=TRUE))
      {
        job_candidate[index,4] <- job_candidate[index,4] + 0.75
      }
      else if(grepl("retired", s, fixed=TRUE))
      {
        job_candidate[index,4] <- job_candidate[index,4] + 0
      }
    }
    job_candidate[index,4] <- (job_candidate[index,4])/(length(c$Status[[1]]))
    
    
    
    c$Activity <- tolower(c$Activity)
    
    ###desperity for a job
    if(grepl("actively looking", c$Activity, fixed=TRUE))
    {
      job_candidate[index,5] <- 1
    }
    else if(grepl("casually looking", c$Activity, fixed=TRUE))
    {
      job_candidate[index,5] <- 0.5
    }
    else if(grepl("not looking", c$Activity, fixed=TRUE))
    {
      job_candidate[index,5] <- 0
    }
    
    
    
    ###determine date available to start
    if(!is.na(c$Availability))
    {
      c$Availability <- tolower(c$Availability)
      c$Availability <- gsub("in ", "", c$Availability, fixed=TRUE)
      c$Availability <- gsub("a ", "", c$Availability, fixed=TRUE)
      
      currDate <- strsplit(as.character.Date(Sys.Date()), '-')
      
      if(grepl("immediately", c$Availability, fixed=TRUE))
      {
        c$Availability <- c$Availability
      }
      else if(length(c$Availability[[1]]) != 0)
      {
        if(length(c$Availability[[1]]) == 1)
        {
          if(grepl("year", c$Availability[[1]], fixed=TRUE))
          {
            currDate[[1]][1] <- as.integer(currDate[[1]][1]) + 1
            c$Availability <- currDate
          }
          else if(grepl("month", c$Availability[[1]], fixed=TRUE))
          {
            if(as.integer(currDate[[1]][2]) + 1 > 12)
            {
              currDate[[1]][2] <- as.integer(currDate[[1]][2]) + 1 - 12
              c$Availability <- currDate
            }
            else
            {
              currDate[[1]][2] <- as.integer(currDate[[1]][2]) + 1
              c$Availability <- currDate
            }
          }
          else if(grepl("week", c$Availability[[1]], fixed=TRUE))
          {
            if(as.integer(currDate[[1]][3]) + 7 > 30)
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + 7 - 30
              c$Availability <- currDate
              
              if(as.integer(currDate[[1]][2]) + 1 > 12)
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + 1 - 12
                c$Availability <- currDate
              }
              else
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + 1
                c$Availability <- currDate
              }
            }
            else
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + 7
              c$Availability <- currDate
            }
          }
          else if(grepl("day", c$Availability[[1]], fixed=TRUE))
          {
            if(as.integer(currDate[[1]][3]) + 1 > 30)
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + 1 - 30
              c$Availability <- currDate
              
              if(as.integer(currDate[[1]][2]) + 1 > 12)
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + 1 - 12
                c$Availability <- currDate
              }
              else
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + 1
                c$Availability <- currDate
              }
            }
            else
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + 1
              c$Availability <- currDate
            }
          }
        }
        else
        {
          c$Availability <- strsplit(c$Availability, ' ')
          
          if(grepl("year", c$Availability[[1]], fixed=TRUE))
          {
            currDate[[1]][1] <- as.integer(currDate[[1]][1]) + as.integer(c$Availability[[1]][1])
            c$Availability <- currDate
          }
          else if(grepl("month", c$Availability[[1]], fixed=TRUE))
          {
            if(as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1]) > 12)
            {
              currDate[[1]][2] <- as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1]) - 12
              c$Availability <- currDate
            }
            else
            {
              currDate[[1]][2] <- as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1])
              c$Availability <- currDate
            }
          }
          else if(grepl("week", c$Availability[[1]], fixed=TRUE))
          {
            if(as.integer(currDate[[1]][3]) + 7*as.integer(c$Availability[[1]][1]) > 30)
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + 7*as.integer(c$Availability[[1]][1]) - 30
              c$Availability <- currDate
              
              if(as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1]) > 12)
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1]) - 12
                c$Availability <- currDate
              }
              else
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1])
                c$Availability <- currDate
              }
            }
            else
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + 7*as.integer(c$Availability[[1]][1])
              c$Availability <- currDate
            }
          }
          else if(grepl("day", c$Availability[[1]], fixed=TRUE))
          {
            if(as.integer(currDate[[1]][3]) + as.integer(c$Availability[[1]][1]) > 30)
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + as.integer(c$Availability[[1]][1]) - 30
              c$Availability <- currDate
              
              if(as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1]) > 12)
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1]) - 12
                c$Availability <- currDate
              }
              else
              {
                currDate[[1]][2] <- as.integer(currDate[[1]][2]) + as.integer(c$Availability[[1]][1])
                c$Availability <- currDate
              }
            }
            else
            {
              currDate[[1]][3] <- as.integer(currDate[[1]][3]) + as.integer(c$Availability[[1]][1])
              c$Availability <- currDate
            }
          }
        }
      }
    }
    
    ###availability match
    if(is.na(c$Availability))
    {
      job_candidate[index,6] <- 0
    }
    else if(grepl("immediately", c$Availability, fixed=TRUE))
    {
      job_candidate[index,6] <- 1
    }
    else if(j$Month == as.integer(c$Availability[[1]][2]))
    {
      job_candidate[index,6] <- 0.75
    }
    else if(j$Month > as.integer(c$Availability[[1]][2]))
    {
      job_candidate[index,6] <- 0.5
    }
    else if(j$Month < as.integer(c$Availability[[1]][2]))
    {
      job_candidate[index,6] <- 0.25
    } 
    
    
    
    ##QUALIFICATIONS
    c$Experience.Level <- tolower(c$Experience.Level)
    
    ###experience level match
    if(grepl(c$Experience.Level, j$Eligibility, fixed=TRUE) || grepl(c$Experience.Level, j$Audience, fixed=TRUE))
    {
      job_candidate[index,7] <- 1
    }
    else
    {
      job_candidate[index,7] <- 0.5
    }
    
    
    
    if(!is.na(c$Hard.Skills))
    {
      c$Hard.Skills <- tolower(c$Hard.Skills)
      c$Hard.Skills <- strsplit(c$Hard.Skills,', ')
      
      ###hard skills percent match
      for(h in c$Hard.Skills[[1]])
      {
        if(grepl(h, j$jobpost, fixed=TRUE))
        {
          job_candidate[index,8] <- job_candidate[index,8] + 1
        }
      }
      if(length(c$Hard.Skills[[1]]) != 0)
      {
        job_candidate[index,8] <- (job_candidate[index,8])/length(c$Hard.Skills[[1]])
      }  
    }
    
    
    
    if(!is.na(c$Soft.Skills))
    {
      c$Soft.Skills <- tolower(c$Soft.Skills)
      c$Soft.Skills <- strsplit(c$Soft.Skills,', ')
      
      ###soft skills percent match
      for(o in c$Soft.Skills[[1]])
      {
        if(grepl(o, j$jobpost, fixed=TRUE))
        {
          job_candidate[index,9] <- job_candidate[index,9] + 1
        }
      }
      if(length(c$Soft.Skills[[1]]) != 0)
      {
        job_candidate[index,9] <- (job_candidate[index,9])/length(c$Soft.Skills[[1]])
      }
    }
    
    
    
    ###average match rate (i.e. total/final score)
    #job_candidate[index,10] <- sum(job_candidate[index,1:9])/9
    
    
    
    #LABELLING RESPONSES...
    
    ##CANDIDATE PREFERENCES    
    c$Job.Title <- tolower(c$Job.Title)
    c$Job.Title <- strsplit(c$Job.Title,' ')
    
    ###title percent match
    for(t in c$Job.Title[[1]])
    {
      if(grepl(t, j$Title, fixed=TRUE))
      {
        scores[index,1] <- (scores[index,1]) + 1
      }
    }
    scores[index,1] <- (scores[index,1])/(length(c$Job.Title[[1]]))
    
    
    
    c$Employment.Types <- tolower(c$Employment.Types)
    c$Employment.Types <- strsplit(c$Employment.Types,', ')
    
    ###employment types percent match
    for(e in c$Employment.Types[[1]])
    {
      if(grepl(e, j$Term, fixed=TRUE))
      {
        scores[index,2] <- (scores[index,2]) + 1
      }
    }
    scores[index,2] <- (scores[index,2])/(length(c$Employment.Types[[1]]))
    
    
    
    c$Industries <- tolower(c$Industries)
    c$Industries <- strsplit(c$Industries,', ')
    
    #industries percent match
    for(n in c$Industries[[1]])
    {
      n <- strsplit(n, ' ')
      temp = 0
      
      for(w in n[[1]])
      {
        if(grepl(w, j$jobpost, fixed=TRUE))
        {
          temp <- temp + 1
        } 
      }
      temp <- temp/length(n[[1]])
      scores[index,3] <- scores[index,3] + temp
    }
    scores[index,3] <- (scores[index,3])/(length(c$Industries[[1]]))
    
    
    
    c$Functions <- tolower(c$Functions)
    c$Functions <- strsplit(c$Functions,', ')
    
    #functions percent match
    for(f in c$Functions[[1]])
    {
      f <- strsplit(f, ' ')
      temp = 0
      
      for(x in f[[1]])
      {
        if(grepl(x, j$jobpost, fixed=TRUE))
        {
          temp <- temp + 1
        } 
      }
      temp <- temp/length(f[[1]])
      scores[index,4] <- scores[index,4] + temp
    }
    scores[index,4] <- (scores[index,4])/(length(c$Functions[[1]]))
    
    
    
    #total match rate
    scores[index,5] <- sum(scores[index,1:4])/4
    
    
    
    if(scores[index,5] >= 0.25)
    {
      response[index] <- "Yes"
    }
    #else if(scores[index,5] < 0.5 && scores[index,5] >= 0.25)
    #{
    #  response[index] <- "Maybe"
    #}
    else
    {
      response[index] <- "No"
    }
    
    
    
    index <- index + 1
  }
}