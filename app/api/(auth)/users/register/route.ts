import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { hashPassword } from '@/utils/auth';

const prisma = new PrismaClient();

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { name, email, password, leetcodeId } = body;

  if (!name || !email || !password || !leetcodeId) {
    return NextResponse.json({ message: 'Missing required fields' }, { status: 400 });
  }

  const existingUser = await prisma.user.findUnique({
    where: { email },
  });

  if (existingUser) {
    return NextResponse.json({ message: 'Email already in use' }, { status: 400 });
  }

  const hashedPassword = await hashPassword(password);

  const user = await prisma.user.create({
    data: {
      name,
      email,
      leetcodeId,
      password: hashedPassword,
    },
  });

  return NextResponse.json({ message: 'User created successfully', user }, { status: 201 });
}
