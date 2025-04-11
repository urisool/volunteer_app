buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // تأكد من استخدام النسخة الصحيحة من Gradle و Kotlin
        classpath ("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10")  // النسخة المتوافقة مع Kotlin
        classpath("com.google.gms:google-services:4.3.15")  // إذا كنت تستخدم Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

