//BC Lab Analysis - TESTING 123

// Demographics


gen education_cat=education_num
recode education_cat 1=1 2/3=2 4/6=1 8=1
label define education 1 "Some primary school" 2 "Completed primary school" 3 "Completed senior secondary" 4 "More than secondary"
label values education_cat education


// Data Organisation
 reshape long hwf, i(attributeid) j(hwfs) string
 encode caseid, gen(caseid_num)
 encode hwf, gen(hwf_num)
 encode group, gen(group_num)
 encode location, gen(loc_num)
 
 // Descriptive
 tab hwf_num // check all have 81
 bysort rank: tab hwf_num
 bysort rank: tab group_num hwf_num
 bysort rank: tab loc_num hwf_num, row

 
// Probability ranked first - HWF

 rologit rank ib7.hwf_num, group(caseid_num) reverse 
 * coeff = log-odds of being in a higher category relative to base cateogry
 * With a change from happy tap to jengu, we expect a 0.96 decrease in the log odds of being in a higher rank for appearance. (p<0.001)
 
 testparm i.hwf_num 
 ** P<0.0001 providing very strong evidence for differences between hwf rankings based on appearance
 ** tests that coefficients are jointly zero  
 
 predict hwfrank //predicted values variable already in dataset - hwfrank
 bysort hwf_num: sum hwfrank
 ** x% chance someone ranks each hwf as the best
 
 predict error, stdp
 gen lb = hwfrank - 0.975*error
 gen ub = hwfrank1 + 0.975*error
 
 
 
 // Adult Men
 rologit rank ib7.hwf_num if group_num == 1, group(caseid_num) reverse 
  testparm i.hwf_num 
  predict hwfrank_AM
  bysort hwf_num: sum hwfrank_AM
 
  // Adult Women
 rologit rank ib7.hwf_num if group_num == 2, group(caseid_num) reverse 
  testparm i.hwf_num 
  predict hwfrank_AW
  bysort hwf_num: sum hwfrank_AW
  
   // Caregiver
 rologit rank ib7.hwf_num if group_num == 3, group(caseid_num) reverse 
  testparm i.hwf_num 
  predict hwfrank_CG
  bysort hwf_num: sum hwfrank_CG
  
   // Elderly
 rologit rank ib7.hwf_num if group_num == 4, group(caseid_num) reverse 
  testparm i.hwf_num 
  predict hwfrank_EL
  bysort hwf_num: sum hwfrank_EL
  
   // George
  rologit rank ib7.hwf_num if loc_num == 1, group(caseid_num) reverse 
  testparm i.hwf_num 
  predict hwfrank_george
  bysort hwf_num: sum hwfrank_george
  
  // Matero
 rologit rank ib7.hwf_num if loc_num == 2, group(caseid_num) reverse 
  testparm i.hwf_num 
  predict hwfrank_matero
  bysort hwf_num: sum hwfrank_matero
  
  // Returned
  rologit rank ib7.hwf_num if return_num == 2, group(caseid_num) reverse 
  predict hwfrank_return
  bysort hwf_num: sum hwfrank_return
  
    // Not Returned
  rologit rank ib7.hwf_num if return_num == 1, group(caseid_num) reverse 
  predict hwfrank_notreturn
  bysort hwf_num: sum hwfrank_notreturn
 
 
 // Probability ranked first - Attribute
 
 rologit rank ib7.attribute_num, group(caseid_num) reverse 
 * coeff = log-odds of being in a higher category relative to base cateogry

 
 testparm i.attribute_num 
 ** P<0.0001 providing very strong evidence for differences between attribute rankings 
 ** tests that coefficients are jointly zero  
 
 predict attributerank //predicted values variable already in dataset 
 bysort attribute_num: sum attributerank
 ** x% chance someone ranks each hwf as the best
 
 // Adult Men
 rologit rank ib7.attribute_num if group_num == 1, group(caseid_num) reverse 
  testparm i.attribute_num 
  predict attributerank_AM
  bysort attribute_num: sum attributerank_AM
 
  // Adult Women
  rologit rank ib7.attribute_num if group_num == 2, group(caseid_num) reverse 
  testparm i.attribute_num 
  predict attributerank_AW
  bysort attribute_num: sum attributerank_AW

  
   // Caregiver
   rologit rank ib7.attribute_num if group_num == 3, group(caseid_num) reverse 
  testparm i.attribute_num 
  predict attributerank_CG
  bysort attribute_num: sum attributerank_CG
  
   // Elderly
  rologit rank ib7.attribute_num if group_num == 4, group(caseid_num) reverse 
  testparm i.attribute_num 
  predict attributerank_EL
  bysort attribute_num: sum attributerank_EL

  
   // George
  rologit rank ib7.attribute_num if loc_num == 1, group(caseid_num) reverse 
  testparm i.attribute_num 
  predict attributerank_george
  bysort attirbute_num: sum attributerank_george
  
  // Matero
   rologit rank ib7.attribute_num if loc_num == 2, group(caseid_num) reverse 
  testparm i.attribute_num 
  predict attributerank_matero
  bysort attribute_num: sum attributerank_matero
 
 
 
  
 
// Interaction

 rologit rank ib7.hwf_num##i.group_num, group(id) reverse nofvlabel
 ** Difference of each HWF vs Spatap amongst Adult Men
 ** Difference in SATO tap rankings each group vs adult men
 
 testparm ib7.hwf_num#i.group_num
 
 
 testparm 2.hwf_num#i.group_num 
 // variation in ranking of hwf 2 by group
 
 * Coefficients for change in log odds of each HWF amongst each group
 lincom 1.hwf_num + 1.hwf_num#2.group_num
 lincom 2.hwf_num + 2.hwf_num#2.group_num
 lincom 3.hwf_num + 3.hwf_num#2.group_num
 lincom 4.hwf_num + 4.hwf_num#2.group_num
 lincom 5.hwf_num + 5.hwf_num#2.group_num
 lincom 6.hwf_num + 6.hwf_num#2.group_num
 lincom 8.hwf_num + 8.hwf_num#2.group_num

 lincom 1.hwf_num + 1.hwf_num#1.group_num
 lincom 2.hwf_num + 2.hwf_num#1.group_num
 lincom 3.hwf_num + 3.hwf_num#1.group_num
 lincom 4.hwf_num + 4.hwf_num#1.group_num
 lincom 5.hwf_num + 5.hwf_num#1.group_num
 lincom 6.hwf_num + 6.hwf_num#1.group_num
 lincom 8.hwf_num + 8.hwf_num#1.group_num
 
 lincom 1.hwf_num + 1.hwf_num#3.group_num
 lincom 2.hwf_num + 2.hwf_num#3.group_num
 lincom 3.hwf_num + 3.hwf_num#3.group_num
 lincom 4.hwf_num + 4.hwf_num#3.group_num
 lincom 5.hwf_num + 5.hwf_num#3.group_num
 lincom 6.hwf_num + 6.hwf_num#3.group_num
 lincom 8.hwf_num + 8.hwf_num#3.group_num
 
 lincom 1.hwf_num + 1.hwf_num#4.group_num
 lincom 2.hwf_num + 2.hwf_num#4.group_num
 lincom 3.hwf_num + 3.hwf_num#4.group_num
 lincom 4.hwf_num + 4.hwf_num#4.group_num
 lincom 5.hwf_num + 5.hwf_num#4.group_num
 lincom 6.hwf_num + 6.hwf_num#4.group_num
 lincom 8.hwf_num + 8.hwf_num#4.group_num



* Changes in log odds of each HWFs being ranked first comparing participant groups e.g., change in log odds for happy tap vs baseline in adult men vs adult women. 









 rologit rank i.hwf_num##i.group_num, group(id) reverse nofvlabel
 // 2.hwf_num = change in log odds for jengu vs happy tap amongst adult men (0) // -0.49
 // 2.group_num = change in log odds for happy tap (0) amongst adult women compared to adult men  // 0.042
 // 2.hwf_num#2.group_num = interaction parameter // -0.1885

 -----------------------------------------------------------------------------------
             rank | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
------------------+----------------------------------------------------------------
          hwf_num |
               2  |  -.4947904   .3134626    -1.58   0.114    -1.109166     .119585
               3  |   1.650857   .3158501     5.23   0.000     1.031802    2.269911
               4  |  -.3794139   .3089952    -1.23   0.219    -.9850334    .2262057
               5  |  -.1772083   .3055342    -0.58   0.562    -.7760443    .4216278
               6  |   .2087838   .3077087     0.68   0.497    -.3943142    .8118817
               7  |   -1.13842    .329581    -3.45   0.001    -1.784387   -.4924531
               8  |   .1596003   .3085757     0.52   0.605    -.4451969    .7643974
                  |
        group_num |
               2  |   .0423389   .3409739     0.12   0.901    -.6259576    .7106354
               3  |  -.3279026   .3044691    -1.08   0.281    -.9246511    .2688458
               4  |  -.0098612   .3424397    -0.03   0.977    -.6810307    .6613084
                  |
hwf_num#group_num |
             2 2  |  -.1885301    .493388    -0.38   0.702    -1.155553    .7784925
             2 3  |  -.3619463    .465613    -0.78   0.437    -1.274531    .5506384
             2 4  |  -.2526743   .5127111    -0.49   0.622     -1.25757     .752221
             3 2  |  -.6798892   .4855023    -1.40   0.161    -1.631456    .2716779
             3 3  |    .526524   .4438083     1.19   0.235    -.3433242    1.396372
             3 4  |  -.8509381   .4862579    -1.75   0.080    -1.803986    .1021098
             4 2  |   .3726459   .4775988     0.78   0.435    -.5634305    1.308722
             4 3  |   .4437526   .4310594     1.03   0.303    -.4011083    1.288613
             4 4  |   .3031363   .4864035     0.62   0.533    -.6501971     1.25647
             5 2  |  -.1255464   .4777916    -0.26   0.793    -1.062001     .810908
             5 3  |  -.0741269   .4325186    -0.17   0.864    -.9218477     .773594
             5 4  |  -.6358111   .4925379    -1.29   0.197    -1.601168    .3295455
             6 2  |  -.6238756   .4886452    -1.28   0.202    -1.581603    .3338515
             6 3  |   .1651099   .4321465     0.38   0.702    -.6818816    1.012101
             6 4  |  -.3852012   .4839624    -0.80   0.426     -1.33375    .5633476
             7 2  |   .2961207   .5083385     0.58   0.560    -.7002045    1.292446
             7 3  |   .9345366   .4507948     2.07   0.038     .0509949    1.818078
             7 4  |   .4966148   .5022533     0.99   0.323    -.4877835    1.481013
             8 2  |  -.6027449   .4940214    -1.22   0.222    -1.571009    .3655193
             8 3  |   .8317847   .4329383     1.92   0.055    -.0167587    1.680328
             8 4  |  -.0849032   .4852606    -0.17   0.861    -1.035997    .8661902
-----------------------------------------------------------------------------------

margins, predict(rank(1))
 
 
lincom 2.hwf_num + 2.hwf_num#2.group_num // change in log odds for jengu vs happy tap amongst adult women (-0.68)

 
------------------------------------------------------------------------------
        rank | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
         (1) |  -.6833205   .3810808    -1.79   0.073    -1.430225    .0635842
------------------------------------------------------------------------------

 rologit rank i.hwf_num if group_num == 2, group(caseid_num) reverse // Comparison: Happy tap to Jengu amongst adult women = -0.5981272 (95%CI -1.61 to 0.41, 0.246) - compared to above

lincom 2.group_num + 2.hwf_num#2.group_num // change in log odds of jengu being ranked first in adult women vs adult men (0.66) - no difference p=0.057

------------------------------------------------------------------------------
        rank | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
         (1) |   .6603491   .3462485     1.91   0.057    -.0182855    1.338984
------------------------------------------------------------------------------



rologit rank i.hwf_num##ib3.group_num, group(id) reverse nofvlabel

-----------------------------------------------------------------------------------
             rank | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
------------------+----------------------------------------------------------------
          hwf_num |
               2  |  -.3139291   .3140059    -1.00   0.317    -.9293694    .3015111
               3  |  -.4164419   .3108587    -1.34   0.180    -1.025714      .19283
               4  |   -2.43557   .3370764    -7.23   0.000    -3.096227   -1.774912
               5  |  -2.303341   .3238186    -7.11   0.000    -2.938014   -1.668668
               6  |  -2.196663   .3252682    -6.75   0.000    -2.834177   -1.559149
               7  |  -2.328934   .3209425    -7.26   0.000     -2.95797   -1.699899
               8  |  -2.160173   .3307762    -6.53   0.000    -2.808482   -1.511863
                  |
        group_num |
               1  |   .5040359   .3159879     1.60   0.111    -.1152891    1.123361
               2  |   .8671461   .3588941     2.42   0.016     .1637266    1.570566
               4  |   .3202262   .3520465     0.91   0.363    -.3697723    1.010225
                  |
hwf_num#group_num |
             2 1  |  -.3222555   .4420666    -0.73   0.466     -1.18869    .5441792
             2 2  |  -.0250166   .4957243    -0.05   0.960    -.9966184    .9465851
             2 4  |  -2.020112   .5142644    -3.93   0.000    -3.028051   -1.012172
             3 1  |  -.6187229   .4365529    -1.42   0.156    -1.474351    .2369051
             3 2  |  -1.926092   .4999472    -3.85   0.000    -2.905971   -.9462141
             3 4  |  -.5247231   .4894776    -1.07   0.284    -1.484082    .4346354
             4 1  |  -.0879567   .4590052    -0.19   0.848    -.9875904     .811677
             4 2  |   .0945982   .5012958     0.19   0.850    -.8879235     1.07712
             4 4  |   .0567449   .5035031     0.11   0.910     -.930103    1.043593
             5 1  |  -.1124099   .4429396    -0.25   0.800    -.9805557    .7557358
             5 2  |   -.513493   .4963199    -1.03   0.301    -1.486262    .4592762
             5 4  |  -.2530986   .5075372    -0.50   0.618    -1.247853     .741656
             6 1  |  -.5062427   .4466588    -1.13   0.257    -1.381678    .3691925
             6 2  |  -1.686718   .5417831    -3.11   0.002    -2.748593   -.6248425
             6 4  |  -.2165208   .5050805    -0.43   0.668     -1.20646    .7734188
             7 1  |  -.5846032   .4507503    -1.30   0.195    -1.468057    .2988511
             7 2  |  -.7752373   .4968021    -1.56   0.119    -1.748952    .1984769
             7 4  |   -.509087   .5071039    -1.00   0.315    -1.502992    .4848183
             8 1  |  -.5775012   .4582465    -1.26   0.208    -1.475648    .3206455
             8 2  |  -.6973874   .5042461    -1.38   0.167    -1.685692    .2909167
             8 4  |   .3079764   .4996336     0.62   0.538    -.6712875     1.28724
-----------------------------------------------------------------------------------

lincom 2.hwf_num + 2.hwf_num#2.group_num // change in log odds for jengu vs happy tapp amongst adult women (WHY DIFFERENT)

------------------------------------------------------------------------------
        rank | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
         (1) |  -.3389458   .3805617    -0.89   0.373    -1.084833    .4069415
------------------------------------------------------------------------------



lincom 2.group_num + 1.hwf_num#2.group_num // change in log odds of happy tap being ranked first comparing adult women to elderly = 0.87 (P=0.016)

------------------------------------------------------------------------------
        rank | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
         (1) |   .8671461   .3588941     2.42   0.016     .1637266    1.570566
------------------------------------------------------------------------------


   testparm i.hwf_num##i.group_num
 ** p<0.001 - there is strong evidence that ranking of hwfs changes with group
 ** tests that the slopes of interacted group variables are jointly zero
 ** tests for evidence against assumption of constant ranking of hwf by group
 
 rologit rank i.hwf_num##i.group_num, group(id) reverse nofvlabel
 estimates store A
 rologit rank i.hwf_num i.group_num, group(id) reverse 
 estimates store B
 lrtest B A
 
 
 
 
 // Hypothesis that later rankings more random than first decisions
 
 rologit rank ib7.hwf_num, group(caseid_num) reverse 
 estimates store Ranking
 by caseid_num (rank), sort: gen best = rank == rank[_N]  
 ** estimate decision weights on basis of most preferred alternatives only (1=best alternatives, 0=otherwise)
 ** by specifying (rank) with by caseid_num, we ensure data is sorted in increasing order on rank within caseid_num. Hence, most preferred alternatives are last in the sort order. 
 ** Expression rank == rank[_N] is true (1) for the most preferred alternatives, even if the alternative is not unique, and false (0) otherwise. 
 
 by caseid_num (rank), sort: assert rank[_N-1] != rank[_N] 
 * Ascertains whether there are ties in selected data. 
 
 rologit best ib7.hwf_num, group(caseid_num) reverse 
 estimates store Choice
 hausman Choice Ranking
 ** p<0.0001 so there is evidence to reject null hypothesis that difference in coefficients is not systematic. There is evidence of misspecification and that same decision weights are not applied at first stage and later stages. 

 
// Interaction (one #)

  rologit rank i.hwf_num#i.group_num, group(id) reverse 
  testparm i.hwf_num#i.group_num
 ** P<0.001 providing very strong evidence that ranking of hwf by attribute changes with group
 
 rologit rank i.hwf_num#i.group_num, group(id) reverse 
 estimates store A
 rologit rank i.hwf_num i.group_num, group(id) reverse 
 estimates store B
 lrtest B A
 
 predict hwf_groupint
 bysort hwf_num group_num: sum hwf_groupint
 ** % chance different groups ranks y as best hwf - I am not sure that this is correct as % are very small
 
 
 
 // Graphs
 
 twoway connected happytap jengu kalingalinga kohler sanitap satotap spatap tippytap  attribute_num // linegraph
 
 
 gen hwfrank_percent = hwfrank*100
 gen hwfrank_AM_percent = hwfrank_AM*100
 gen hwfrank_AA_percent = hwfrank_AW*100
 gen hwfrank_CG_percent = hwfrank_CG*100
 gen hwfrank_EL_percent = hwfrank_EL*100
 gen hwfrank_matero_percent = hwfrank_matero*100
 gen hwfrank_george_percent = hwfrank_george*100

 graph bar hwfrank_percent hwfrank_AM_percent hwfrank_AA_percent hwfrank_CG_percent hwfrank_EL_percent, over(hwf_num) // bar graph - groups
 graph bar hwfrank_AM_percent hwfrank_AA_percent hwfrank_CG_percent hwfrank_EL_percent, over(hwf_num) // bar graph - no all groups
  graph bar hwfrank_percent, over(hwf_num) // bar graph - overall
 
  gen hwfrank_matero_percent = hwfrank_matero*100
 gen hwfrank_george_percent = hwfrank_george*100
 
 graph bar hwfrank_george_percent hwfrank_matero_percent, over(hwf_num) 
 
 graph bar hwfrank_george_percent hwfrank_matero_percent, over(hwf_num) /// legend
 

graph bar hwfrank_george_percent hwfrank_matero_percent, over(hwf_num) ///
    ytitle("Probability HWF Ranked First (%)") ///
	legend(label(1 "George") label(2 "Matero")) 
	
	
graph bar attributerank_Geo_percent attributerank_Mat_percent, over(attribute_num) ///
    ytitle("Probability Attribute Ranked Most Important (%)") ///
	legend(label(1 "George") label(2 "Matero")) 


gen attributerank_percent = attributerank*100
gen attributerank_AM_percent = attributerank_AM*100
gen attributerank_AW_percent = attributerank_AW*100
gen attributerank_CG_percent = attributerank_CG*100
gen attributerank_EL_percent = attributerank_EL*100
gen attributerank_Mat_percent = attributerank_matero*100
gen attributerank_Geo_percent = attributerank_george*100

graph bar attributerank_percent, over(attribute_num)

 graph bar attributerank_percent attributerank_AM_percent attributerank_AW_percent attributerank_CG_percent attributerank_EL_percent, over(attribute_num) // bar graph - groups
 graph bar attributerank_AM_percent attributerank_AW_percent attributerank_CG_percent attributerank_EL_percent, over(attribute_num) 
 
 graph bar attributerank_Mat_percent attributerank_Geo_percent, over(attribute_num)
  
  

twoway line y1 y2 y3 x, sort by(catvar)



// Interaction - Happy Tap
  rologit rank i.hwf_num##i.group_num, group(id) reverse nofvlabel // take group coefficients (compared with adult ment)
 

