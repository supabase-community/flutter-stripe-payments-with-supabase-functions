allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // stripe_android depends on Google's private Tap and Pay SDK, which is not
    // published to any public repository and is only needed for push
    // provisioning: https://github.com/flutter-stripe/flutter_stripe/issues/2471
    configurations.configureEach {
        exclude(group = "com.google.android.gms", module = "play-services-tapandpay")
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
