//
//  DataUtil.swift
//  DoctorMap
//
//  Created by Kushagra Gupta on 25/08/16.
//  Copyright © 2016 Kushagra Gupta. All rights reserved.
//

import UIKit

class DataUtil: NSArray {
    
    static let Specialities = [
    "Dentist",
    "General Physician",
    "Ayurveda",
    "Pediatrician",
    "Orthopedist",
    "Dermatologist",
    "Gynecologist/obstetrician",
    "Homeopath",
    "Gynecologist",
    "General Surgeon",
    "Physiotherapist",
    "Dental Surgeon",
    "Cardiologist",
    "Orthodontist",
    "Implantologist",
    "Cosmetologist",
    "Diabetologist",
    "Oral And Maxillofacial Surgeon",
    "Obstetrician",
    "Ophthalmologist",
    "Ophthalmologist/ Eye Surgeon",
    "Ear-Nose-Throat (Ent) Specialist",
    "Psychiatrist",
    "Ent/ Otorhinolaryngologist",
    "Urologist",
    "Endodontist",
    "Cosmetic/aesthetic Dentist",
    "Periodontist",
    "Internal Medicine",
    "Radiologist",
    "Dietitian/nutritionist",
    "Prosthodontist",
    "Spa",
    "Orthopedic Surgeon",
    "Neurologist",
    "Pediatric Dentist",
    "Plastic Surgeon",
    "Gastroenterologist",
    "Infertility Specialist",
    "Psychologist",
    "Neurosurgeon",
    "Pulmonologist",
    "Wellness",
    "Saloon",
    "Hair Transplant Surgeon",
    "Laparoscopic Surgeon",
    "Audiologist",
    "Oncologist",
    "Beautician",
    "Clinical Physiotherapist",
    "Spa Therapist",
    "Acupuncturist",
    "Yoga And Naturopathy",
    "Sexologist",
    "Trichologist",
    "Surgical Oncologist",
    "Speech Therapist",
    "Andrologist",
    "Alternative Medicine",
    "Head And Neck Surgeon",
    "Family Physician",
    "Anesthesiologist",
    "Neonatologist",
    "Consultant Physician",
    "Medical Oncologist",
    "Allergist/immunologist",
    "Counselling Psychologist",
    "Spine Surgeon",
    "Rheumatologist",
    "Psychotherapist",
    "Sports And Musculoskeletal Physiotherapist",
    "Clinical Psychologist",
    "Bariatric Surgeon",
    "Reproductive Endocrinologist (Infertilty)",
    "Dentofacial Orthopedist",
    "Nephrologist",
    "Nephrologist/renal Specialist",
    "Veterinarian",
    "Orthopedic Physiotherapist",
    "Veterinary Physician",
    "Gastrointestinal Surgery",
    "Cardiothoracic Surgeon",
    "Endocrinologist",
    "Pathologist",
    "Joint Replacement Surgeon",
    "General Pathologist",
    "Venereologist",
    "General Endocrinologist",
    "Preventive Dentistry",
    "Spine And Pain Specialist",
    "Pediatric Surgeon",
    "Vascular Surgeon",
    "Neuro Physiotherapist",
    "Urogynecologist",
    "Obesity Specialist",
    "Aesthetic Dermatologist",
    "Sports Medicine Surgeon",
    "Geriatric Physiotherapist",
    "Dermatosurgeon",
    "Paediatric Intensivist",
    "Oral Medicine And Radiology",
    "Interventional Cardiologist",
    "Occupational Therapist",
    "Hand Surgeon",
    "Gastroentrology Surgeon",
    "Addiction Psychiatrist",
    "Pediatric Dermatologist",
    "Veterinary Surgeon",
    "Geriatrician",
    "Cardiovascular And Pulmonary Physiotherapist",
    "Restorative Dentist",
    "Preventive Medicine",
    "Urological Surgeon",
    "Hematologist",
    "Hematologic Oncologist",
    "Oral Pathologist",
    "Adolescent And Child Psychiatrist",
    "Aesthetic Medicine",
    "Pain Management Specialist",
    "Neuropsychiatrist",
    "Sonologist",
    "Colorectal Surgeon",
    "Orthopedist And Traumatology Specialist",
    "Somnologist",
    "Rhinologist",
    "Pediatric Orthopedic Surgeon",
    "Cosmetic Dermatovenereologist",
    "Cardiac Surgeon",
    "Unani",
    "Radiation Oncologist",
    "Pediatric Cardiologist",
    "Otologist/ Neurotologist",
    "Total Joint Surgeon",
    "Primary Care Dentist",
    "Pediatric Physiotherapist",
    "General Practitioner",
    "Geriatric Psychiatrist",
    "Temporal Mandibular Dysfunction & Orofacial Pain Specialist",
    "Somnologist (Sleep Specialist)",
    "Optometrist",
    "Operative Dentist",
    "Emergency & Critical Care",
    "Sports Medicine Specialist",
    "Hepatologist",
    "Rehab & Physical Medicine Specialist",
    "Pediatric Otorhinolaryngologist",
    "Hepato-Biliary-Pancreatic",
    "Gynecologic Oncologist",
    "Sleeping Disorders Specialist",
    "Pediatric Urologist",
    "Health Psychologist",
    "Hypnotherapist",
    "Ultrasonologist",
    "Sports Nutritionist",
    "Pediatric Neurologist",
    "Pediatric Endocrinologist",
    "Opticians",
    "Optician",
    "Hair Stylist",
    "Dentist For Patients With Special Needs",
    "Breast Surgeon",
    "Knee Surgeon",
    "Stomatologist",
    "Sports Medicine Physician",
    "Neurodevelopmental Psychiatrist",
    "Siddha",
    "Occupational Psychologist",
    "Geriatric Dentist",
    "Endoscopist",
    "Endocrine Surgeon",
    "Sport Injury Specialist",
    "Ent, Head And Neck Surgeon",
    "Educational Psychologist",
    "Critical Care Medicine",
    "Social Obstetrics And Gynecologist",
    "Psychosomatic Specialist",
    "Pediatric Sleep Medicine Specialist",
    "Neurobehaviour Specialist",
    "Consultation-Liaison Psychiatrist",
    "Proctologist",
    "Oral Maxillofacial Prosthetician",
    "Echocardiologist",
    "Clinical Embryologist",
    "Functional Urologist",
    "Female Urologist",
    "Social Dentist",
    "Sexual Psychologist",
    "Public Health Dentist",
    "Intestine Surgeon",
    "Emergency Medicine",
    "Digestive Endoscopist",
    "Growth And Development - Community Pediatrician",
    "Cataract And Refractive Surgeon",
    "Trauma & Orthopaedic Physiotherapist",
    "Orthodontist & Dentofacial Orthopedist",
    "Nuclear Medicine Physician",
    "Neuroendocrinologist",
    "Geneticist",
    "Forensic Dentist",
    "Female Pelvic And Reconstructive Surgeon",
    "Chronic Liver Specialist",
    "Chiropractor",
    "Cardiothoracic And Vascular Surgeon",
    "Pediatric Urologist And Reconstruction Surgeon",
    "Women's Health Physiotherapist",
    "Plastic, Reconstructive, Aesthetic Surgeon",
    "Pediatric Pulmonologist",
    "Geriatric Neurologist",
    "Family Psychologist",
    "Family And Community Medicine Specialist",
    "Dermatopathologist",
    "Orthopedist Of Superior Extremity",
    "Genito Urinary Medicine Physician",
    "Gastroenterology-Hepatologist",
    "Rheumatology Physiotherapist",
    "Pediatric Gastroenterologist",
    "Interventional Radiologist",
    "Hospital Dentist",
    "Dermatovenereologist",
    "Dental Prosthetician",
    "Child Behavior Therapist",
    "Ayurvedic Preventive Medicine Specialist",
    "Ayurvedic Endocrinologist & Internal Medicine Specialist",
    "Aesthetic Surgeon",
    "Sexual And Reproductive Health Specialist",
    "Reproductive Health Specialist",
    "Musculoskeletal Rehabilitation Specialist",
    "Maternal And Fetal Medicine Specialist",
    "Laryngo-Pharyngologist",
    "External Genitalia Surgeon",
    "Digestive System Surgeon",
    "Digestive Surgeon",
    "Asthma And Chronic Obstructive Pulmonary Disease Specialist",
    "Pediatric Ot",
    "Neuropsychologist",
    "Infectious Diseases Physician",
    "Immunologist",
    "Holistic Psychotherapist",
    "Clinical Immunologist",
    "Burn Surgeon",
    "Urogynecologist And Hip Reconstructive Surgeon",
    "Orthopedist Of Inferior Extremity",
    "Head And Neck Oncologist",
    "Diagnostic Radiologist",
    "Work Psychologist",
    "Vascular Cardiologist",
    "Respiratory Physiotherapist",
    "Public Health Physiotherapist",
    "Psychoanalytic Therapist",
    "Preventive Cardiologist And Rehabilitation Specialist",
    "Pediatric Rheumatologist",
    "Palliative Care Physician",
    "Occupational Therapist For Mental Health",
    "Micro Surgeon",
    "Massotherapist",
    "Gynecology & Obstetrics Ultrasonologist",
    "Endocrinology",
    "Electrotherapist",
    "Dental Labor Specialist",
    "Cardiac Electrophysiologist",
    "Ayurvedic Pharmacologist",
    "Ayurvedic Gynecologist & Obstetrician",
    "Acupressure",
    "Vitreoretina Specialist",
    "Headache And Vertigo Specialist",
    "Glaucoma Specialist",
    "Geriatric Medicine Specialist",
    "Veterinary Homeopath",
    "Toxicologist",
    "Radiology & Diagnostic Imaging Specialist",
    "Plastic Reconstruction Surgeon",
    "Pediatric Oncologist",
    "Neurofunctional Physiotherapist",
    "Neonatal Surgeon",
    "Immunodermatologist",
    "Gynaecological Endoscopist",
    "Forensic Psychiatrist",
    "Clinical/biomedical Toxicologist",
    "Bone Marrow Transplant Surgeon",
    "Traditional Indian Medicine Practitioner",
    "Stroke Specialist",
    "Pediatric Ophthalmologist And Strabismus Specialist",
    "Pediatric Development And Behavioral Medicine Specialist",
    "Otologist",
    "Obstetrics And Gynecology Radiologist",
    "Neurospine Surgeon",
    "Neuromuscular Rehabilitation Specialist",
    "Veterinary Toxicologist",
    "Vascular Ultrasound With Doppler Specialist",
    "Thoracic (Chest) Surgeon",
    "Tcm Physician (Traditional Chinese Medicine)",
    "Sports Psychologist",
    "Special Educator For Learning Disability",
    "Siddha Diabetologist",
    "Pharmacist",
    "Pediatric Immunologist And Allergist",
    "Pediatric Hematologic-Oncologist",
    "Orthotist",
    "Ocularist",
    "Occupational Medicine Specialist",
    "Medical Microbiologist",
    "Legal Medicine & Medical Expertise Specilaist",
    "Intensive Medicine Specilaist",
    "Hiv Specialist",
    "Health Administration Specilaist",
    "Genetic Counselor",
    "Dental Hygienist",
    "Clinical Hematologist",
    "Children's Infectious Diseases Physician",
    "Ayurvedic Surgeon",
    "Ayurvedic Orthopedist",
    "Ayurvedic Nutritionist",
    "Aviation And Aerospace Medicine Specialist",
    "Arrhythmia Specialist",
    "Adolescent Medicine Physician",
    "Urethra Radiologist",
    "Thoracic Radiologist",
    "Spirometry Specialist",
    "Respiratory Therapy Specialist",
    "Prostate And Bladder Radiologist",
    "Pediatric Radiologist",
    "Pediatric Nutrition And Metabolic Disease Specialist",
    "Pediatric Gastro-Hepatologist",
    "Neuro-Ophthamologist",
    "Musculoskeletal Radiologist",
    "Infectious And Tropical Medicine Physician",
    "Community Ent Specialist",
    "Coloproctologist",
    "Clinical Medicine Specialist",
    "Breast Radiologist",
    "Reiki Therapist",
    "Reconstruction",
    "Public Health Specialist",
    "Perinatologist",
    "Pediatric Dermatovenereologist",
    "Parenteral And Enteral Nutritionist",
    "Pain Management Anesthesiologist",
    "Oncofuncional Physiotherapist",
    "Obs & Gyn Laparoscopic Surgeon",
    "Neuro-Oncologist",
    "Invasive Cardiologist",
    "Integrative Medicine Physician",
    "Integrated Medicine",
    "Hospital Administration Specialist",
    "Functional Orthopedist",
    "Forensic Psychologist",
    "Electro Homoeopathy",
    "Dermatofuncional Physiotherapist",
    "Ache Specialist",
    "Pulmonologist And Respiratory Medicine Specialist",
    "Pediatric Sports Medicine Specialist",
    "Pediatric Orthopedist",
    "Pediatric Nephrologist",
    "Pediatric Infectious Disease Physician",
    "Pediatric Emergency Medicine Specialist",
    "Orthopedic Oncologist",
    "Obstetrics And Gynecology Anatomical Pathologist",
    "Neurotologist",
    "Neurooncology Surgeon",
    "Neurodevelopmental Disabilities Specialist",
    "Infections And Immunology In Ophthalmology Specialist",
    "Hijama Cupping Practitioner",
    "Bladder Stones Specialist"
    ]

}
