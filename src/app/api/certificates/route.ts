import { NextRequest, NextResponse } from 'next/server';
import CredentialDetail from "@/models/credentialModel"
import mongoose from 'mongoose';
import { connectDB } from "@/dbConfig/dbconfig";

connectDB();
export async function GET() {
  try {
    const credentials = await CredentialDetail.find({});
    return NextResponse.json(credentials);
  } catch (error) {
    return NextResponse.json({ error: 'Failed to fetch credentials' }, { status: 500 });
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const credential = new CredentialDetail(body);
    await credential.save();
    return NextResponse.json(credential, { status: 201 });
  } catch (error) {
    return NextResponse.json({ error: 'Failed to add credential' }, { status: 500 });
  }
}