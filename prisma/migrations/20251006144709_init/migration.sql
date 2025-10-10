-- CreateEnum
CREATE TYPE "Role" AS ENUM ('LEARNER', 'ISSUER', 'VERIFIER', 'ADMIN');

-- CreateEnum
CREATE TYPE "VerificationStatus" AS ENUM ('PENDING', 'VERIFIED', 'REJECTED');

-- CreateEnum
CREATE TYPE "AccessStatus" AS ENUM ('PENDING', 'APPROVED', 'DENIED');

-- CreateEnum
CREATE TYPE "VerificationSource" AS ENUM ('API_PULL', 'ISSUER_PUSH', 'DIGILOCKER');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "fullName" TEXT,
    "role" "Role" NOT NULL DEFAULT 'LEARNER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LearnerProfile" (
    "id" TEXT NOT NULL,
    "headline" TEXT,
    "about" TEXT,
    "profilePictureUrl" TEXT,
    "uniqueShareLink" TEXT NOT NULL,
    "userId" TEXT NOT NULL,

    CONSTRAINT "LearnerProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IssuerProfile" (
    "id" TEXT NOT NULL,
    "organizationName" TEXT NOT NULL,
    "websiteUrl" TEXT,
    "verificationStatus" "VerificationStatus" NOT NULL DEFAULT 'PENDING',
    "apiKey" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "IssuerProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerifierProfile" (
    "id" TEXT NOT NULL,
    "companyName" TEXT NOT NULL,
    "jobTitle" TEXT,
    "verificationStatus" "VerificationStatus" NOT NULL DEFAULT 'PENDING',
    "userId" TEXT NOT NULL,

    CONSTRAINT "VerifierProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Credential" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "mongodbDocumentId" TEXT NOT NULL,
    "issuedOn" TIMESTAMP(3) NOT NULL,
    "nsqfLevel" TEXT,
    "verificationSource" "VerificationSource" NOT NULL,
    "learnerId" TEXT NOT NULL,
    "issuerId" TEXT NOT NULL,

    CONSTRAINT "Credential_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AccessRequest" (
    "id" TEXT NOT NULL,
    "status" "AccessStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "verifierId" TEXT NOT NULL,
    "learnerId" TEXT NOT NULL,

    CONSTRAINT "AccessRequest_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "LearnerProfile_uniqueShareLink_key" ON "LearnerProfile"("uniqueShareLink");

-- CreateIndex
CREATE UNIQUE INDEX "LearnerProfile_userId_key" ON "LearnerProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "IssuerProfile_apiKey_key" ON "IssuerProfile"("apiKey");

-- CreateIndex
CREATE UNIQUE INDEX "IssuerProfile_userId_key" ON "IssuerProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "VerifierProfile_userId_key" ON "VerifierProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Credential_mongodbDocumentId_key" ON "Credential"("mongodbDocumentId");

-- CreateIndex
CREATE INDEX "Credential_learnerId_idx" ON "Credential"("learnerId");

-- CreateIndex
CREATE INDEX "Credential_issuerId_idx" ON "Credential"("issuerId");

-- CreateIndex
CREATE INDEX "AccessRequest_verifierId_idx" ON "AccessRequest"("verifierId");

-- CreateIndex
CREATE INDEX "AccessRequest_learnerId_idx" ON "AccessRequest"("learnerId");

-- AddForeignKey
ALTER TABLE "LearnerProfile" ADD CONSTRAINT "LearnerProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssuerProfile" ADD CONSTRAINT "IssuerProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "VerifierProfile" ADD CONSTRAINT "VerifierProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Credential" ADD CONSTRAINT "Credential_learnerId_fkey" FOREIGN KEY ("learnerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Credential" ADD CONSTRAINT "Credential_issuerId_fkey" FOREIGN KEY ("issuerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccessRequest" ADD CONSTRAINT "AccessRequest_verifierId_fkey" FOREIGN KEY ("verifierId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccessRequest" ADD CONSTRAINT "AccessRequest_learnerId_fkey" FOREIGN KEY ("learnerId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
