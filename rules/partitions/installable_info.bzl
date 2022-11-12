"""
Copyright (C) 2022 The Android Open Source Project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"""

load("//build/bazel/rules/apex:apex.bzl", "ApexInfo")

InstallableInfo = provider(
    "If a target provides InstallableInfo, it means it can be installed on a partition image.",
    fields = {
        "files": "A dictionary mapping from the path to the file to install to the path it should have in the partition.",
    },
)

def _installable_aspect_impl(target, ctx):
    installed_files = {}
    if ApexInfo in target:
        apex = target[ApexInfo].signed_output
        installed_files[apex] = "/system/apex/" + apex.basename

    if not installed_files:
        return []

    return [
        InstallableInfo(
            files = installed_files,
        ),
    ]

# This aspect is intended to be applied on a apex.native_shared_libs attribute
installable_aspect = aspect(
    implementation = _installable_aspect_impl,
    attrs = {},
)