package com.xebia.spark.randomForestClassification.stubs


import com.xebia.spark.randomForestClassification.stubs.features.Engineering
import com.xebia.spark.randomForestClassification.stubs.tools.Utilities._
import com.xebia.spark.randomForestClassification.stubs.modelling.TreeModelling.{randomForestTrainClassifier, gridSearchRandomForestClassifier}
import org.apache.spark.{SparkContext, SparkConf}


object RandomForestClassificationGrid {

  def main(args: Array[String]) {

    val conf = new SparkConf().setAppName("RandomForest").setMaster("local[4]").set("spark.executor.memory", "6g")
    val sc = new SparkContext(conf)

    // Loading data
    // TODO : read file ./src/main/resources/data_titanic.csv

    // Parsing Data
    // TODO : use function in tools/Utilities to get an RDD without header

    // Feature Engineering
    // TODO : use the featureEngineering method in features/Engineering to get the cleaned data

    // Splitting data
    // TODO : split the cleaned data in a train, validation and test set (proportions 0.70, 0.15, 0.15) using the 'randomSplit' method

    // Modelling
    // -------- Tuning parameters
    val categoricalFeaturesInfo = Map(1 -> 2, 6 -> 4)
    // TODO : complete the gridSearchRandomForestClassifier method in package tools.Utilities
    // TODO : use the gridSearchRandomForestClassifier method to test several parameters of your choice (Use the train and validation sets)

    // -------- Training the model
    // TODO : use the randomForestTrainClassifier method to train a Random Forest (Using the best parameters found)

    // Prediction & Evaluation
    // TODO : get the accuracy and confusion matrix for the prediction on the test set using the getMetricsDecisionTree method
    // TODO : do the same for the train set for comparison

    // Print results
    // TODO : print the best parameters found

    println(s"Results for the training set")
    // TODO : print the results obtained for the train set

    println(s"Results for the test set")
    // TODO : print the results obtained for the test set

  }

}
