# .NET Static Files - Docker Image Sizes

**UPDATED FOR .NET 6.0 IMAGES AND NEW HOSTING MODEL**

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

| Image|.NET App Publish Approach|Size|
|---|---|---|
| 1 - Nginx | N/A | 133MB |
| 2 - .NET 5.0.5 (default tag) | Framework-Dependent | 206MB |
| 3 - .NET 5.0.5 Focal | Framework-Dependent | 213MB |
| 4 - .NET 5.0.5 Alpine 3.12 | Framework-Dependent | 103MB |
| 5 - .NET 5.0.5 Alpine 3.13 | Framework-Dependent | 103MB |
| 6 - .NET 5.0.5 Buster Slim | Framework-Dependent | 206MB |
| 7 - .NET 5.0.5 Runtime Deps | Self-Contained | 50.2MB |
| 8 - .NET 5.0.5 Distroless TAKE ONE (Alpine 3.13) | Self-Contained | 81.5MB |
| 9 - .NET 5.0.5 Distroless TAKE TWO (Runtime Deps) | Self-Contained | 48.4MB |
| 10 - **.NET 6.0** (default tag) | Framework-Dependent | 208MB |
| 11 - **.NET 6.0** Runtime Deps | Self-Contained | 50.1MB |
| 12 - **.NET 6.0** Distroless (Runtime Deps) | Self-Contained | 46.4MB |

## So I should use Self-Contained then, right?

As always... it depends.

Take a second to read this article by Andrew Lock on the topic https://andrewlock.net/should-i-use-self-contained-or-framework-dependent-publishing-in-docker-images/.

The summary at the end goes to explain about how Docker caches layers. So if you have multiple images using the same layers, then you will likely see benefit from caching layers.

Here's the recreation of the table from Andrew's post with the new information:

| Layer | Cached? | Framework-dependent | Self-contained |
|---|---|---|---|
| Base runtime dependencies | Yes | 8.4MB | 8.4MB |
| Shared framework layer| Yes | 93MB | - |
| Application DLLs| No | 269KB | 40MB |
| Total | | 102.4MB | 48.4MB |
| Total (excluding cached)| | 269kB | 40MB |

Obviously, the test application here is really simple and the difference between loading 269kB vs 40MB on modern hardware is probably minimal. So, deciding between Framework-dependent or Self-contained will largely depend on your circumstances.

However, I can strongly recomment going Distroless...

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

## References

- https://github.com/dotnet/dotnet-docker/issues/2074
- https://ariadne.space/2021/09/09/introducing-witchery-tools-for-building-distroless-images-with-alpine/
- https://itnext.io/smaller-docker-images-for-asp-net-core-apps-bee4a8fd1277
- https://medium.com/01001101/containerize-your-net-core-app-the-right-way-35c267224a8d
- https://techcommunity.microsoft.com/t5/azure-developer-community-blog/hardening-an-asp-net-container-running-on-kubernetes/ba-p/2542224