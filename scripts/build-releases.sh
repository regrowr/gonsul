#!/usr/bin/env bash
# Script to build gonsul for multiple platforms, ready for upload as a GitHub release
set -euo pipefail

app=cmd/gonsul.go
output_dir="releases"
package_name=gonsul
platforms=("darwin/amd64" "darwin/arm64" "linux/amd64" "linux/arm64" )

# Create the output directory if it doesn't exist
mkdir -p $output_dir

for platform in "${platforms[@]}"
do
	platform_split=(${platform//\// })
	GOOS=${platform_split[0]}
	GOARCH=${platform_split[1]}
	output_name=$output_dir/$package_name

	if ! env GOOS="$GOOS" GOARCH="$GOARCH" go build -o $output_name $app; then
   		echo 'An error has occurred! Aborting the script execution...'
		exit 1
	fi

	# Zip the binary
	zip -j $output_dir/"$GOOS"-"$GOARCH"-"$package_name".zip "$output_name"

	# Remove the binary
	rm "$output_name"
done