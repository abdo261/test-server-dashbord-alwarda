-- CreateEnum
CREATE TYPE "Sex" AS ENUM ('HOMME', 'FEMME');

-- CreateEnum
CREATE TYPE "SchoolStady" AS ENUM ('COLLEGE', 'LYCEE', 'ECOLE_PRIMAIRE');

-- CreateTable
CREATE TABLE "Users" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "isOwner" BOOLEAN NOT NULL DEFAULT false,
    "centreId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Levels" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" "SchoolStady" NOT NULL DEFAULT 'LYCEE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Levels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Students" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "phoneParent" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "sex" "Sex" NOT NULL,
    "school" "SchoolStady" NOT NULL DEFAULT 'LYCEE',
    "registrationDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "registredBy" INTEGER,
    "levelId" INTEGER,
    "centreId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Students_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Centres" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "color" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Centres_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Subjects" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "pricePerMonth" DOUBLE PRECISION NOT NULL,
    "levelId" INTEGER,
    "school" "SchoolStady" NOT NULL DEFAULT 'LYCEE',
    "teacherId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Subjects_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payments" (
    "id" SERIAL NOT NULL,
    "studentId" INTEGER NOT NULL,
    "month" TEXT NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "amountPaid" DOUBLE PRECISION NOT NULL,
    "amountDue" DOUBLE PRECISION NOT NULL,
    "discount" DOUBLE PRECISION NOT NULL,
    "startAt" TIMESTAMP(3) NOT NULL,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "have50" INTEGER DEFAULT 0,
    "subjects" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Teachers" (
    "id" SERIAL NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "sex" "Sex" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Teachers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_StudentsToSubjects" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Users_email_key" ON "Users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Users_centreId_key" ON "Users"("centreId");

-- CreateIndex
CREATE UNIQUE INDEX "Levels_name_key" ON "Levels"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Centres_name_key" ON "Centres"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Centres_color_key" ON "Centres"("color");

-- CreateIndex
CREATE UNIQUE INDEX "Subjects_name_levelId_key" ON "Subjects"("name", "levelId");

-- CreateIndex
CREATE UNIQUE INDEX "_StudentsToSubjects_AB_unique" ON "_StudentsToSubjects"("A", "B");

-- CreateIndex
CREATE INDEX "_StudentsToSubjects_B_index" ON "_StudentsToSubjects"("B");

-- AddForeignKey
ALTER TABLE "Users" ADD CONSTRAINT "Users_centreId_fkey" FOREIGN KEY ("centreId") REFERENCES "Centres"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Students" ADD CONSTRAINT "Students_registredBy_fkey" FOREIGN KEY ("registredBy") REFERENCES "Users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Students" ADD CONSTRAINT "Students_levelId_fkey" FOREIGN KEY ("levelId") REFERENCES "Levels"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Students" ADD CONSTRAINT "Students_centreId_fkey" FOREIGN KEY ("centreId") REFERENCES "Centres"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subjects" ADD CONSTRAINT "Subjects_levelId_fkey" FOREIGN KEY ("levelId") REFERENCES "Levels"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Subjects" ADD CONSTRAINT "Subjects_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES "Teachers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payments" ADD CONSTRAINT "Payments_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_StudentsToSubjects" ADD CONSTRAINT "_StudentsToSubjects_A_fkey" FOREIGN KEY ("A") REFERENCES "Students"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_StudentsToSubjects" ADD CONSTRAINT "_StudentsToSubjects_B_fkey" FOREIGN KEY ("B") REFERENCES "Subjects"("id") ON DELETE CASCADE ON UPDATE CASCADE;
