package com.xebia.spark.kMeansClustering

import org.apache.spark.{SparkConf, SparkContext}

object KMeansClusteringStubs {

   def main(args: Array[String]) {

     val conf = new SparkConf().setAppName("KMeans").setMaster("local[4]").set("spark.executor.memory", "6g")
     val sc = new SparkContext(conf)

     // Loading data
     // TODO : read file ./src/main/resources/data_titanic.csv

     // Parsing Data
     // TODO : use function in tools/Utilities to get an RDD without header

     // Feature Engineering
     // TODO : use the featureEngineering method in features/Engineering to get the cleaned data.
     // Be carefull, you will get a RDD[LabeledPoint]

     // Get the features
     // TODO : get the data we want to analyse (RDD[Vector])

     // Modelling
     // TODO : Train a KMeans model on the data set

     // Evaluation
     // TODO : Call the getMetrics method in tools/Utilities on the data set

     // Print results
     // TODO : print confusion matrix and accuracy

     // Inspect population of each cluster
     // TODO : For each cluster look the center and the percentage of survivor. Use the getStatsPerCluster method in tools/Utilities


   }

 }
