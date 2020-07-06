# Notes on Traveling the Trail
(this is based on notes from https://gamefaqs.gamespot.com/appleii/579985-the-oregon-trail/faqs/9660
as well as my own guesstimations.)

## Rations
* Filling = three pounds of food per person per day
* Meager = two " " " " " " "
* Bare bones = one " " " " " " "

## Travel distance per day
Up to Fort Laramie, you can travel a maximum of forty miles per day. After Fort Laramie, you
can travel a maximum of twenty-four miles per day. To this maximum, apply the following multipliers:

* Yoke of oxen (1 yoke of oxen = 50%, 2 yoke of oxen = 75%, 3+ yoke of oxen = 100%)
* Pace (Steady = 50%, Strenuous = 75%, Grueling = 100%)

For example, if you're not yet to Fort Laramie, you have two yoke of oxen, and you're doing a strenuous
pace, you will travel the following distance per day:

40 * 75% * 75% = 22.5

My thought is that I can implement this using bit shifting:

* Multiply by 50%? Just bitshift to the right one time (LSR). Note that this will discard the remainder,
but that's alright.
* Multiply by 75%? Bitshift to the right two times (LSR & LSR) and call that X. Then, add X shifted left (ROL, or 2X) + X. Again, this will disregard the remainder, but that's OK with me.

## Small landmark icons on the trail
Small landmark icons are visible on the left side of the traveling screen once the distance to the landmark is less
than 100 miles. The icon will move right across the screen until it's just to the left of the ox/wagon icons,
representing 0 miles. Hence, we can calculate how many miles each pixel represents. As we travel each day, slide the
landmark icon to the right the appropriate number of pixels for that day's travel.
