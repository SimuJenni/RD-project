function [ mask ] = activityMask( activity, lowQ, highQ )
%ACTIVITYMASK Generates a mask indicating which pixels of the activity are
%within a band defined by the given quantiles of the activity distribution.

lowB = quantile(activity(:), lowQ);
highB = quantile(activity(:), highQ);

mask = (activity >= lowB) & (activity <= highB);

end

