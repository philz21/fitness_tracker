import { test, expect } from '@playwright/test';

test.describe('Progress chart', () => {
  test.beforeEach(async ({ page }) => {
    // Seed: add a couple of entries directly via UI
    await page.goto('/');

    // Bench Press day 1
    await page.getByLabel('Date').fill('2025-12-01');
    await page.getByLabel('Exercise').fill('Bench Press');
    await page.getByLabel('Sets').fill('3');
    await page.getByLabel('Reps').fill('8');
    await page.getByLabel('Weight (kg)').fill('60');
    await page.getByRole('button', { name: 'Save workout' }).click();

    // Bench Press day 2 (heavier)
    await page.getByLabel('Date').fill('2025-12-05');
    await page.getByLabel('Exercise').fill('Bench Press');
    await page.getByLabel('Sets').fill('3');
    await page.getByLabel('Reps').fill('8');
    await page.getByLabel('Weight (kg)').fill('70');
    await page.getByRole('button', { name: 'Save workout' }).click();
  });

  test('shows filtered chart for a single exercise', async ({ page }) => {
    await page.goto('/progress');

    // Select Bench Press from dropdown
    await page.getByLabel('Filter by exercise').selectOption('Bench Press');
    await page.getByRole('button', { name: 'Apply filter' }).click();

    // Check that the subtitle updates
    await expect(page.getByText('Showing progress for Bench Press')).toBeVisible();

     const chartContainer = page.locator('div[id^="chart-"]');

    // Check that chart container exists
    await expect(chartContainer).toBeVisible();

    await expect(chartContainer.locator('svg')).toBeVisible();
  });
});