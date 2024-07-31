/*
  Warnings:

  - A unique constraint covering the columns `[leetcodeId]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `leetcodeId` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Category" AS ENUM ('NORMAL', 'TEACHER_ASSIGNED', 'CONTEST');

-- CreateEnum
CREATE TYPE "Difficulty" AS ENUM ('Easy', 'Medium', 'Hard');

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "leetcodeId" TEXT NOT NULL,
ADD COLUMN     "teamId" INTEGER,
ADD COLUMN     "totalPoints" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "Team" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "totalPoints" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TeacherQuestion" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "points" INTEGER NOT NULL,
    "deadline" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "TeacherQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Solution" (
    "id" SERIAL NOT NULL,
    "submissionID" INTEGER NOT NULL,
    "userId" INTEGER NOT NULL,
    "category" "Category" NOT NULL,
    "teamId" INTEGER,
    "questionId" INTEGER NOT NULL,
    "points" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Solution_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LeetCodeQuestion" (
    "id" SERIAL NOT NULL,
    "acRate" DOUBLE PRECISION NOT NULL,
    "difficulty" "Difficulty" NOT NULL,
    "frontendQuestionId" TEXT NOT NULL,
    "status" TEXT,
    "title" TEXT NOT NULL,
    "titleSlug" TEXT NOT NULL,

    CONSTRAINT "LeetCodeQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Contest" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "startTime" INTEGER NOT NULL,

    CONSTRAINT "Contest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ContestParticipation" (
    "id" SERIAL NOT NULL,
    "attended" BOOLEAN NOT NULL,
    "problemsSolved" INTEGER NOT NULL,
    "totalProblems" INTEGER NOT NULL,
    "finishTimeInSeconds" INTEGER NOT NULL,
    "contestId" INTEGER NOT NULL,

    CONSTRAINT "ContestParticipation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_TeacherQuestions" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "LeetCodeQuestion_frontendQuestionId_key" ON "LeetCodeQuestion"("frontendQuestionId");

-- CreateIndex
CREATE UNIQUE INDEX "_TeacherQuestions_AB_unique" ON "_TeacherQuestions"("A", "B");

-- CreateIndex
CREATE INDEX "_TeacherQuestions_B_index" ON "_TeacherQuestions"("B");

-- CreateIndex
CREATE UNIQUE INDEX "User_leetcodeId_key" ON "User"("leetcodeId");

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Solution" ADD CONSTRAINT "Solution_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Solution" ADD CONSTRAINT "Solution_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Solution" ADD CONSTRAINT "Solution_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "LeetCodeQuestion"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ContestParticipation" ADD CONSTRAINT "ContestParticipation_contestId_fkey" FOREIGN KEY ("contestId") REFERENCES "Contest"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TeacherQuestions" ADD CONSTRAINT "_TeacherQuestions_A_fkey" FOREIGN KEY ("A") REFERENCES "LeetCodeQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_TeacherQuestions" ADD CONSTRAINT "_TeacherQuestions_B_fkey" FOREIGN KEY ("B") REFERENCES "TeacherQuestion"("id") ON DELETE CASCADE ON UPDATE CASCADE;
