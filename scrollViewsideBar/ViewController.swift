//
//  ViewController.swift
//  scrollViewsideBar
//
//  Created by Vmock on 13/07/16.
//  Copyright © 2016 comicsanshq. All rights reserved.
//

import UIKit

enum drawerState
{
	case open, closed
}
class ViewController: UIViewController, UIGestureRecognizerDelegate
{
	
	let colors = [UIColor.blackColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.darkGrayColor()]
	let scrollView = UIScrollView()
	var animator: UIDynamicAnimator?
	var snapBehaviour: UISnapBehavior?
	let drawer = UIView()
	var sliderDrawerState = drawerState.closed
	override func viewDidLoad()
	{
		super.viewDidLoad()
		scrollView.frame = self.view.frame
		scrollView.contentSize.width  = self.view.frame.width
		scrollView.contentSize.height  = self.view.frame.height * 2
		scrollView.backgroundColor = UIColor.orangeColor()
		self.view.addSubview(scrollView)
		let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.pan(_:)))
		pan.delegate = self
		scrollView.addGestureRecognizer(pan)
		animator = UIDynamicAnimator(referenceView: self.view)
		drawer.frame = CGRectMake(self.view.frame.width, 0, 40, self.view.frame.height)
		drawer.backgroundColor = UIColor.darkGrayColor()
		self.view.backgroundColor = UIColor.darkGrayColor()
		self.view.addSubview(drawer)
		let randoSub1 = UIView(frame: CGRectMake(0, 0, 40, 100))
		let randoSub2 = UIView(frame: CGRectMake(0, 100, 40, 100))
		let randoSub3 = UIView(frame: CGRectMake(0, 200, 40, 100))
		randoSub1.backgroundColor = UIColor.purpleColor()
		randoSub2.backgroundColor = UIColor.blueColor()
		randoSub3.backgroundColor = UIColor.greenColor()
		[randoSub1, randoSub2, randoSub3].forEach({ (randomView) in
			drawer.addSubview(randomView)
		})
		for i in 0...5
		{
			let contentView = UIView(frame: CGRectMake(0,CGFloat(i)*200,100,100 ))
			contentView.backgroundColor = UIColor.whiteColor()
			scrollView.addSubview(contentView)
		}
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	
	func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool
	{
		if let pan = gestureRecognizer as? UIPanGestureRecognizer
		{
			let translation = pan.translationInView(self.view)
			let isHorizontalPan = (abs(translation.x) > 3 * abs(translation.y)) ? true : false
			return isHorizontalPan
		}
		else
		{
			return false
		}
	}
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool
	{
		return true
	}
	
	func pan(sender:AnyObject)
	{
		animator?.removeAllBehaviors()
		if let pan = sender as? UIPanGestureRecognizer
		{
			print(pan.translationInView(self.view).x )
			if (scrollView.frame.origin.x < -40)  && sliderDrawerState == .closed
			{
				UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations:
					{
						self.drawer.frame.origin = CGPointMake(self.view.frame.width - 40, 0)
						self.sliderDrawerState = .open
					}, completion: { (completion) in
						
				})
			}
			else if (scrollView.frame.origin.x > -40 || pan.translationInView(self.view).x > 0) && sliderDrawerState == .open
			{
				UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations:
					{
						self.drawer.frame.origin = CGPointMake(self.view.frame.width, 0)
						self.sliderDrawerState = .closed
					}, completion: { (completion) in
						
				})
			}
			if pan.state == .Ended
			{
				var snapPoint = CGPointZero
				if sliderDrawerState == .open
				{
					snapPoint = CGPointMake(self.view.frame.width/2 - 40, self.view.frame.height/2)
				}
				else
				{
					snapPoint = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
				}
				snapBehaviour = UISnapBehavior(item: scrollView, snapToPoint: snapPoint)
				snapBehaviour?.damping = 1
				animator?.addBehavior(snapBehaviour!)
				let dynItem = UIDynamicItemBehavior(items: [scrollView])
				dynItem.allowsRotation = false
				animator?.addBehavior(dynItem)
			}
			print(pan.translationInView(scrollView).x)
			scrollView.frame.origin.x = self.view.frame.origin.x +  pan.translationInView(self.view).x
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

