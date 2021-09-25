# .NET Static Files - Docker Image Sizes

## Docker Commands

See the `build.ps1` script for the commands used to generate these images.

For the first nine images (everything except for "final"), run this command from the root.

```
./build.ps1 -name {foldername}
```

If you want to build the "final" image, run the command:
```
./build.ps1 -name {foldername} -port 8080
```

Why is the last one different? Because I've further hardened the image by running on a port that doesn't require root access.

## Results

|Image|Size|
|---|---|
|1 - Nginx | 133MB |
|2 - .NET 5.0.5 (default tag) | 206MB |
|3 - .NET 5.0.5 Focal | 213MB |
|4 - .NET 5.0.5 Alpine 3.12 | 103MB |
|5 - .NET 5.0.5 Alpine 3.13 | 103MB |
|6 - .NET 5.0.5 Buster Slim | 206MB |
|7 - .NET 5.0.5 Runtime Deps | 50.2MB |
|8 - .NET 5.0.5 Distroless TAKE ONE (Alpine 3.13) | 81.5MB |
|9 - .NET 5.0.5 Distroless TAKE TWO (Runtime Deps) | 48.4MB |

## Why Distroless?

Don't listen to me, listen to these guys...
- https://github.com/GoogleContainerTools/distroless
- https://cloud.redhat.com/blog/hardening-docker-containers-images-and-host-security-toolkit

The TL;DR; is that distroless images only contain YOUR application and its dependencies. No shells such as bash, sh, etc.

## Examing the images

You can explore any of these images (once you build them locally) using the fantastic "Dive" app. See https://github.com/wagoodman/dive.

Run the command:
```
dive dpbevin/staticfiles-9-distroless2
```

# References

- https://github.com/dotnet/dotnet-docker/issues/2074
- https://ariadne.space/2021/09/09/introducing-witchery-tools-for-building-distroless-images-with-alpine/
- https://itnext.io/smaller-docker-images-for-asp-net-core-apps-bee4a8fd1277
- https://medium.com/01001101/containerize-your-net-core-app-the-right-way-35c267224a8d
- https://techcommunity.microsoft.com/t5/azure-developer-community-blog/hardening-an-asp-net-container-running-on-kubernetes/ba-p/2542224