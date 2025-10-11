import mongoose, { Schema, Document } from 'mongoose';

// Define the structure for the embedded issuer details
const IssuerDetailsSchema = new Schema({
  name: { type: String, required: true },
  logo_url: { type: String }
}, { _id: false }); 

// Define the structure for the embedded learner details
const LearnerDetailsSchema = new Schema({
  name: { type: String, required: true },
  email: { type: String, required: true }
}, { _id: false });

// Define the structure for dates
const DatesSchema = new Schema({
  issued_on: { type: Date, required: true },
  expires_on: { type: Date }
}, { _id: false });

// Define the structure for URLs
const UrlsSchema = new Schema({
  credential_url: { type: String },
  verification_url: { type: String }
}, { _id: false });


// Main Schema for Credential Details
const CredentialDetailSchema = new Schema({
  // This field links this MongoDB document back to your PostgreSQL 'Credential' table.
  // It's the most important link between your two databases.
  credential_postgres_id: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },
  title: {
    type: String,
    required: true,
  },
  description: {
    type: String,
  },
  issuer_details: IssuerDetailsSchema,
  learner_details: LearnerDetailsSchema,
  dates: DatesSchema,
  urls: UrlsSchema,
  skills_acquired: {
    type: [String],
    default: [],
  },
  // This is the flexible "catch-all" field.
  // You can store any JSON object here, accommodating the different data
  // from Coursera, Microsoft, a YouTuber, etc.
  raw_data: {
    type: Schema.Types.Mixed,
    default: {},
  },
}, {
  // This option automatically adds `createdAt` and `updatedAt` fields.
  timestamps: true,
});

// Create and export the Mongoose model
const CredentialDetail = mongoose.model('CredentialDetail', CredentialDetailSchema);

export default CredentialDetail;