#estimate the Gelman statistics to access convergence of the independent runs
library(coda)
library(BayesianTools)
library(stringr)

#get the data that was completed i = 800 iterations

#list the name of files with results
MCMC_results1 <- list.files("Analysis_SD/phydynR/MCMC_results/ICL_cluster/importation_rate/high/region1000global500/all_tree/run1/results_10000bp", recursive = TRUE, full.names = TRUE)
MCMC_results2 <- list.files("Analysis_SD/phydynR/MCMC_results/ICL_cluster/importation_rate/high/region1000global500/all_tree/run2/results_10000bp", recursive = TRUE, full.names = TRUE)

MCMC_results_iter.data1 <- MCMC_results1[grepl("iter.rdata", MCMC_results1)]
length(MCMC_results_iter.data1)
MCMC_results_out1 <- MCMC_results1[grepl("out_sim.RDS", MCMC_results1)]
length(MCMC_results_out1)

MCMC_results_iter.data2 <- MCMC_results2[grepl("iter.rdata", MCMC_results2)]
length(MCMC_results_iter.data2)
MCMC_results_out2 <- MCMC_results2[grepl("out_sim.RDS", MCMC_results2)]
length(MCMC_results_out2)

for(j in 1:length(MCMC_results_iter.data1)){

  run_number1 <- str_split(MCMC_results_iter.data1[j], "/")[[1]][11]
  run_number2 <- str_split(MCMC_results_iter.data2[j], "/")[[1]][11]

  if(run_number1 != run_number2){

    run_number1 <- str_split(run_number1, "_")[[1]][2]
    run_number2 <- str_split(run_number2, "_")[[1]][2]


  }

  if(run_number1 == run_number2){

    load(MCMC_results_iter.data1[j])
    #print(i)
    i1 <- i

    load(MCMC_results_iter.data2[j])
    #print(i)
    i2 <- i

    if(i1 != i2){

      print(j)
      print(i1)
      print(i2)
      print("most likely it will need to run for longer")

    }

    #then it will
    if(i1 == i2 & i1 == 801){


      #print(j)
      #print(MCMC_results_iter.data1[j])
      #print(MCMC_results_iter.data2[j])


      out1 <- readRDS(MCMC_results_out1[j])
      out2 <- readRDS(MCMC_results_out2[j])

      #convert to coda
      out_sample1 <- BayesianTools::getSample(out1, start=5000, coda = TRUE)
      out_sample2 <- BayesianTools::getSample(out2, start=5000, coda = TRUE)

      mcmc_combined <- createMcmcSamplerList(list(out1, out2))


      #quartz()
      #as a rule of thumb values below 1.1 or so is OK
      #(https://theoreticalecology.wordpress.com/2011/12/09/mcmc-chain-analysis-and-convergence-diagnostics-with-coda-in-r/)
      convergence_res <- gelmanDiagnostics(mcmc_combined, plot = FALSE)
      #print(convergence_res)

      #if(convergence_res$mpsrf >= 1.10){

        #print(j)

      #}

      ESS1 <- coda::effectiveSize(out_sample1)
      ESS2 <- coda::effectiveSize(out_sample2)

      if(any(ESS1 < 200) | any(ESS2 < 200)){

        print(j)
        print("low ESS")

      }


      if(convergence_res$psrf[3,2] >= 1.10){

        print(j)
        print(convergence_res)

        if(any(ESS1 < 200) | any(ESS2 < 200)){

          print(j)
          print("low ESS and gelman stats >= 1.1")

        }
        if(all(ESS1 > 200) & all(ESS2 > 200)){

          print(j)
          print("high ESS and gelman stats >= 1.1")

        }


      }else{

        if(all(ESS1 > 200) & all(ESS2 > 200)){

          print(j)
          print("good ESS and gelman stats < 1.1")

        }

      }





      #teste <- summary(out_coda)
      #marginalPlot(out, names = c(ESTNAMES, ELOWER, EUPPER), start = 7500)

      #get ESS values
      #print(j)
      #print(ESS1 <- coda::effectiveSize(out_sample1))
      #print(ESS2 <- coda::effectiveSize(out_sample2))

    }
  } else (print("run1 different from run2: double check data!"))
}



out <- readRDS("Analysis_SD/phydynR/MCMC_results/region1000global500/1000bp/stage6_1/out_sim.RDS")

#convert to coda
out_coda <- BayesianTools::getSample(out, start = 1, coda = TRUE)
summary(out_coda)
#quartz()

#plot results
plot(out_coda, ask = TRUE)
