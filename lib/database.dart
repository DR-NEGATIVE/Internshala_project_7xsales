import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getData() async {
  var Data = await FirebaseFirestore.instance.collection('Videos');
  return Data.get();
}
