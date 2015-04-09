package com.xebia.spark.kMeansClustering.stubs

import com.xebia.spark.kMeansClustering.stubs.features.Engineering.featureEngineering
import com.xebia.spark.kMeansClustering.stubs.tools.Utilities.{extractHeader, getMetrics}
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.mllib.clustering.KMeans

object KMeansClustering {

   def main(args: Array[String]) {

     val conf = new SparkConf().setAppName("KMeans").setMaster("local[4]").set("spark.executor.memory", "6g")
     val sc = new SparkContext(conf)

     // Loading data
     // TODO : read file ./src/main/resources/data_titanic.csv

     // Parsing Data
     // TODO : use function in tools/Utilities to get an RDD without header

     // Feature Engineering
     // TODO : use the featureEngineering method in features/Engineering to get cleaned data.
     // Be carefull, you will get a RDD[(Vector, Double)] containing the data we want to analyse
     // and the labels

     // TODO : put the data(RDD[Vector]) and the labels (RDD[Double]) in two different variables

     // Modelling
     // TODO : Train a KMeans model on the data set

     // Evaluation
     // TODO : Call the getMetrics method in tools/Utilities on the data set

     // TODO : print confusion matrix and accuracy


   }

 }
