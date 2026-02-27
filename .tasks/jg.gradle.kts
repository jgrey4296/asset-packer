// //  jg.gradle.kts<3> -*- mode: Kotlin -*-

class JGScriptPlugin: Plugin<Project> {
    /* A Simple Plugin Script Example

     */

    fun simpleFunction () {
        println("simple function")
    }

    override fun apply(project: Project) {
        val providers = project.providers
        project.tasks.register("jg") {
            group = "JG"
            val myname: String? by project
            val myval = "blah"


            doFirst {
                println("---- Starting ----")
                println("Start action")
            }

            doLast {
                println("---- Finishing ----")
                println("Value: ${myname ?: "not provided"}")
                providers.exec {
                    commandLine("echo", myval)
                }
                simpleFunction()
            }

        }
    }
}

apply<JGScriptPlugin>()
