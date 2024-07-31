import { NextRequest, NextResponse } from 'next/server';
import { PrismaClient } from '@prisma/client';
import { comparePassword, generateToken } from '@/utils/auth';

const prisma = new PrismaClient();

export async function POST(req: NextRequest) {
  const body = await req.json();
  const { email, password } = body;

  if (!email || !password) {
    return NextResponse.json({ message: 'Missing required fields' }, { status: 400 });
  }

  const user = await prisma.user.findUnique({
    where: { email },
  });

  if (!user) {
    return NextResponse.json({ message: 'Invalid email or password' }, { status: 401 });
  }

  const isPasswordValid = await comparePassword(password, user.password);

  if (!isPasswordValid) {
    return NextResponse.json({ message: 'Invalid email or password' }, { status: 401 });
  }

  const token = generateToken({ id: user.id });

  return NextResponse.json({ message: 'Login successful', token, user: { id: user.id, name: user.name, email: user.email, leetcodeId: user.leetcodeId } }, { status: 200 });
}
