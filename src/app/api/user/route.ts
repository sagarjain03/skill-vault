import { NextResponse } from "next/server";
import { db } from "@/lib/db";
import { hash } from "bcryptjs"; // Use bcryptjs for Next.js API routes

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { email, password, fullName, role } = body;

    // Check if email already exists
    const existingUser = await db.user.findUnique({
      where: { email: email },
    });
    if (existingUser) {
      return NextResponse.json({ error: "Email already exists" }, { status: 409 });
    }

    const hashedPassword = await hash(password, 10);
    const newUser = await db.user.create({
      data: {
        fullName,
        email,
        password: hashedPassword,
        role,
      },
    });

    return NextResponse.json(
      { user: newUser, message: "User created successfully" },
      { status: 201 }
    );
  } catch (error: any) {
    return NextResponse.json({ error: error?.message || "Internal server error" }, { status: 500 });
  }
}