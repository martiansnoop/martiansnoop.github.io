---
layout: post
title:  "Today I started storing images in an S3 bucket"
date:   2016-12-29 15:03:00 -0800
categories: meta
---

It's easy to add images to a jekyll blog by checking them into the blog repo, but I don't like storing lots of large binary files in git because the repo gets huge and I write while connected to a VPN on coffee shop wifi so I don't want to deal with a giant git repo. 

The aws cli `sync`command is great for this: I wrote a tiny script to sync the assets directory, and then vice versa so I can keep the directory in sync on the two computers that I use regularly. I also want to write a script to automatically resize images to a few different widths and set up some kind of jekyll template to both make images responsive to screen size and also link to a larger image. That is my next project.

This isn't a detailed how-to guide as much as it's some words I wrote down to chronicle my adventures and missteps with AWS.  

This is how I automated uploading images to S3:

* make an S3 bucket (also create an aws account if not already done)
* make an IAM user with which to upload images to that bucket
* make an IAM profile that describes the permissions necessary to upload objects to the bucket
* assign the IAM profile to the IAM user
* generate IAM access keys for the user (since this user is intended to be used via command line only, no need to create login credentials)
* use `aws configure --profile upload` and enter the key and secret when prompted 
  * this creates an entry in ~/.aws/credentials for the profile named "upload". Use via `aws --profile upload s3 sync <etc>`. 
* use [this small script][s3-script] to upload local images and pull down images I uploaded on another computer.  

The first problem I ran into was in creating the IAM policy with permissions to upload. I did about three different things wrong:

1. I only included the s3:PutObject permission, but I also needed to list the objects in the bucket to perform the sync. The error message was `A client error (AccessDenied) occurred when calling the ListObjects operation`
2. Then I tried adding the permission s3:ListObjects to the policy and tried the sync command again. Same error message I googled for "aws s3 permissions" and found that the string "ListObjects" is not a valid permission. The error message was that I needed to have the "ListBucket" **permission** in order to do the "ListObjects" **operation**.   
3. The sync command still failed with the same AccessDenied error, so I googled for "aws s3 sync policy" for an example and discovered that I needed to put the "ListBucket" permission on the **bucket**, and then put the "PutObject" permission on the **objects in the bucket**.    

Then it worked. This is the final policy (replace `bucket-name` with the actual name of the bucket, note that the first block just has `bucket-name` but the second block has `bucket-name/*`):

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3::bucket-name"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-name/*"
            ]
        }
    ]
}
```

Then I used my aws s3 sync script to upload the images from my challah blog post. The next step was to make the images available on the internet so I can display them here. 

I first thought that, in order to do that, I needed to set up the bucket for static site hosting. I tried this, but I found that whenever I tried to access the images I got a 403. I spent some time googling for how to use an s3 bucket to host images and found that I needed to create a policy granting the GetObject permission to everyone. I tried to make a policy via the IAM interface, but it wouldn't let me save because IAM policies could not have the property "Principal". In addition to IAM policies, you can also put policies on buckets themselves via the bucket settings interface, and this policy needed to be created that way. 

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::bucket-name/*"
        }
    ]
}
```

The next question I had was "now that the bucket is public, what can I do to stop someone from repeatedly downloading images and charging me a ton of money. I added a billing alert, but that's not going to help me if it happens in the middle of the night. 

[s3-script]: https://github.com/martiansnoop/martiansnoop.github.io/blob/fdb45f10847671813997267ba2b3d60951432641/scripts/upload.sh
