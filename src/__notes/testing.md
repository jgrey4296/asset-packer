<!--  testing.md -*- mode: gfm-mode -*-  -->
<!--
Summary:

Tags:
-->
Test Directory Name: "__tests"

# Testing

## Python

[Pytest](https://docs.pytest.org/en/stable/index.html)

Test Files are of the format "{}_tests.py"
Configured in `pyproject.toml`

## Prolog

## Elixir
```mix test```


[ExUnit](https://hexdocs.pm/ex_unit/1.19.3/ExUnit.html)
`mix.exs` project files set `test_paths` to "__tests".

## Godot

Using [GUT](https://gut.readthedocs.io/en/v9.5.0/).
Run Tests as `godot --no-header --headless -d -s --path "$PWD" addons/gut/gut_cmdln.gd -gexit __tests`
Or throught asdf: `asdf cmd godot test __tests`

## Kotlin
```gradle test```

Basic Framework is:
```kotlin
import kotlin.test.Test
import kotlin.test.assertEquals

class BasicTests {

    @Test
    fun shouldDoMath() {
        assertEquals(2, 2)
    }

}
```

While setting `build.gradle.kts`:
```kotlin
sourceSests {
    test {
        java {
            sourceSets.main.get().java.srcDirs
            srcDir(projDir.dir("__tests"))
        }
    }
}

dependencies {
    testImplementation("org.jetbrains.kotlin:kotlin-test:2.2.21")
}

tasks.test {
    useJUnitPlatform()
}
```

## OPA

## Octave

## Rust

## Supercollider

## Rocq

## Dotnet
Using xunit, modify a `.csproj` file:
```xml
<PropertyGroup>
    <IsTestProject>true</IsTestProject>
</PropertyGroup>

<ItemGroup>
    <PackageReference Include="coverlet.collector" Version="6.0.0" />
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />
    <PackageReference Include="xunit" Version="2.5.3" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.5.3" />
</ItemGroup>

<ItemGroup>
<ProjectReference Include="$(MSBuildThisFileDirectory)../{proj_name}.csproj" />
</ItemGroup>

```
